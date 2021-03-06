module ShepherdSharedExamples

  # This shared example requires an action parameter
  # that passes a function that calls the controller 
  shared_examples_for 'a protected action' do 
    #add variables to hash
    let(:args_hash) do
      hash = {}
      hash[:data] = data if defined? data
      hash[:id] = id if defined? id
      hash
    end

    [:json, :xml, :html].each do |format|            
      context 'without authorization token' do   
        it 'should return 401 unauthorized code for #{format}' do
          args_hash[:format] = format
          action(args_hash)
          expect(response.status).to eq(401)
        end     
      end

      context 'with invalid authorization token' do
        it 'should return 401 unauthorized code for #{format}' do
          args_hash[:format] = format
          request.env['X-AUTH-TOKEN'] = '111'
          action(args_hash)
          expect(response.status).to eq(401)
        end
      end
    end
  end

  # Shared example that test a JSON index action on a controller
  # to see that it returns 406 for other formats and 200
  # for JSON format
  shared_examples_for 'JSON controller index action' do
    def get_index(format, token)
      request.env['X-AUTH-TOKEN'] = token if token
      get :index, format: format
    end

    [:xml, :html].each do |format| 
      it 'should return 406 code for format #{format}' do
        get_index format, @auth_token
        expect(response.status).to eq(406)
      end 
    end    

    before :each do
      get_index :json, @auth_token 
    end

    it_should_behave_like 'an action that responds with JSON'
  end

  shared_examples_for 'JSON controller show action' do
    def get_show(format, token)
      request.env['X-AUTH-TOKEN'] = token if token
      get :show, format: format
    end
  end

  # Test whether response content type returned is JSON
  shared_examples_for 'an action that responds with JSON' do    
    it 'responds with JSON format' do
      expect(response.header['Content-Type']).to include('application/json')
    end
  end

  shared_examples_for 'responds with Location header' do
    it 'includes location header' do
      expect(response.header['Location']).to be_present 
    end
  end

  shared_examples_for 'responds with success 200 status code' do
    it { should respond_with 200 }
  end

  shared_examples_for 'responds with success 201 status code' do
    it { should respond_with 201 }
  end

  shared_examples_for 'responds with 404 not found' do
    it { should respond_with 404 }
  end      

  shared_examples_for 'responds with 406 not acceptable' do
    it { should respond_with 406 }
  end      

  shared_examples_for 'an auditable model' do
    describe 'requires a created by user id' do
      before { subject.created_by_id = nil }
      it { should_not be_valid }
      specify { subject.save.should be false}
    end

    describe 'requires an updated by user id' do
      before { subject.updated_by_id = nil }
      it { should_not be_valid }
      specify { subject.save.should be false }
    end
  end

  shared_examples_for 'a model with timestamps' do
    describe 'timestamps' do
      describe 'save a created by date' do
        before { subject.save }
        specify { subject.created_at.should be_present }
      end

      describe 'save an updated by date' do
        before { subject.save }
        specify { subject.updated_at.should be_present }
      end
    end
  end
end 
