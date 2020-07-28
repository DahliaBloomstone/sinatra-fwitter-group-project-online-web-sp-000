class TweetsController < ApplicationController

  get '/tweets' do
    @tweets = Tweet.all
    if logged_in?
      @user = current_user
      erb :"tweets"
    else
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :"tweets/new"
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
     if logged_in?
       if params[:content] != ""
         user = current_user
         tweet = user.tweets.build(content: params[:content])
       user.save
       redirect "/tweets/#{tweet.id}"
     else
       redirect '/tweets/new'
     end
   else
     redirect '/login'
   end
 end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :"tweets/show"
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id' do
      if logged_in?
        @tweet = Tweet.find(params[:id])
        erb :'tweets/show_tweet'
      else
        redirect '/login'
      end
    end

  patch '/tweets/:id/edit' do
    @tweet = Tweet.find_by(id: params[:id])
    @user = current_user
    if @tweet.update(content: params[:content], user: @user)
      redirect to "/tweets/#{@tweet.id}"
    else
      redirect to "/tweets/#{@tweet.id}/edit"
    end
  end

  delete '/tweets/:id/delete' do
    @tweet = current_user.tweets.find_by(:id => params[:id])
    if @tweet && @tweet.destroy
      redirect "/tweets"
    else
      redirect "/tweets/#{@tweet.id}"
    end
  end

end
