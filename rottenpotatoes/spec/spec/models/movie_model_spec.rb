require 'simplecov'
SimpleCov.start 'rails'
require 'rails_helper'

describe Movie do
  describe '.find_similar_movies' do
     fixtures :movies
     let!(:movie3) { FactoryBot.create(:movie, title: 'Gundam 0080', director: 'Takayoma') }
     let!(:movie4) { FactoryBot.create(:movie, title: "Gundam Unicron") }
    describe 'if director exists' do
      it 'finds similar movies' do
        movie1 = movies(:Wandering_Earth)
        movie2 = movies(:My_Old_Classmate)
        expect(Movie.similar_movies(movie1.title)).to eql(['My Old Classmate', "Wandering Earth"])
        expect(Movie.similar_movies(movie1.title)).to_not include(['Gundam 0080'])
        expect(Movie.similar_movies(movie3.title)).to eql(['Gundam 0080'])
        
      end
    end

    describe 'if director does not exist' do
      it 'exec sad path' do
        expect(Movie.similar_movies(movie4.title)).to eql(nil)
      end
    end
  end

  describe '.all_ratings' do
    it 'returns all ratings' do
      expect(Movie.all_ratings).to match(%w(G PG PG-13 NC-17 R))
    end
  end
end