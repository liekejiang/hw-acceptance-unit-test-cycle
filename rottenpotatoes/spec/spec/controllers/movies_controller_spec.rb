require 'simplecov'
SimpleCov.start 'rails'
require 'rails_helper'

describe MoviesController, type: :controller do
    
    describe "MoviesController#search" do
        describe "When the movie has a director" do
            fixtures :movies
            
            it "should find all movies with the same director" do
                movie1 = movies(:Wandering_Earth)
                movie2 = movies(:My_Old_Classmate)
                
                movies = [movie1.title, movie2.title]
                
                expect(Movie).to receive(:similar_movies).with(movie1.title).and_return(movies)
                get :search, { title: movie1.title }
                expect(assigns(:similar_movies)).to eql(movies)
                expect(response).to render_template(:search)
            end
            
            it "should redirect to home page when no same director" do
                @movie_id = '1551'
                @movie = double(:title => 'wandering_earch', :director => 'guo fan')

                expect(Movie).to receive(:similar_movies).with('wandering_earch')

                get :search, {:title => 'wandering_earch'}

                expect(response).to redirect_to(root_url)
            end
        end

        describe "When the movie has no director" do
            it "should redirect to the movies page" do
                @movie_id = '1551'
                @movie = double(:title => 'wandering_earch')
                expect(Movie).to receive(:similar_movies).with('wandering_earch').and_return(nil)

                get :search, {:title => 'wandering_earch'}
                expect(response).to redirect_to(root_url)
            end
        end

    end


    describe "MoviesController#sort" do
        describe "When sort movies by title" do
            it "should sort all movies by title" do
                get :index, :sort => :title, :ratings => ["R","PG", "G","PG-13"]
            end
        end
        describe "When sort movies by release_date" do
            it "should sort all movies by release_date" do
                get :index, :sort => :release_date, :ratings => ["R","G", "PG", "PG-13"]
            end
        end
    end

    describe "MoviesController#create" do
        describe "When create a movie" do
            it "should create it to database" do
                
                movie_new = Hash.new
                movie_new["title"] = "Wandering Earth"
                movie_new["rating"] = "G"
                movie_new["director"] = "Guo Fan"
                movie_new["release_date"] = Date.new(2019, 2, 4)

                post :create, movie: movie_new
                expect(response).to redirect_to("/movies")
            end
        end
    end
    
    
  describe 'MoviesController#show' do
    let!(:movie) { FactoryBot.create(:movie,title: "Gundam Unicron") }
    before(:each) do
      get :show, id: movie.id
    end

    it 'should find the movie' do
      expect(assigns(:movie)).to eql(movie)
    end

    it 'should render the show in view' do
      expect(response).to render_template('show')
    end
  end
  
  describe 'MoviesController#index' do
    let!(:movie) {FactoryBot.create(:movie,title: "Gundam Unicron") }

    it 'should render the index in view' do
      get :index
      expect(response).to render_template('index')
    end


  end  
end