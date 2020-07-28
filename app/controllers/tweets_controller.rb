class TweetsController < ApplicationController
 get '/tweets' do
   if logged_in?
     @tweets = Tweet.all
     erb :'tweets/tweets'
   else
     redirect to '/login'
   end
 end

 get '/tweets/new' do
   if logged_in?
     erb :'tweets/create_tweet'
   else
     redirect to '/login'
   end
 end

 post '/tweets' do
   if logged_in?
     if params[:content] == ""
       redirect to "/tweets/new"
     else
       @tweet = current_user.tweets.build(content: params[:content])
       if @tweet.save
         redirect to "/tweets/#{@tweet.id}"
       else
         redirect to "/tweets/new"
       end
     end
   else
     redirect to '/login'
   end
 end

 get '/tweets/:id' do
   if logged_in?
     @tweet = Tweet.find_by_id(params[:id])
     erb :'tweets/show_tweet'
   else
     redirect to '/login'
   end
 end

 get '/tweets/:id/edit' do
   if logged_in?
     @tweet = Tweet.find_by_id(params[:id])
     if @tweet && @tweet.user == current_user
       erb :'tweets/edit_tweet'
    else
      redirect to '/tweets'
    end
  else
    redirect to '/login'
  end
end

patch '/tweets/:id' do
  if logged_in?
    if params[:content] == ""
      redirect to "/tweets/#{params[:id]}/edit"
    else
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet && @tweet.user == current_user
        if @tweet.update(content: params[:content])
          redirect to "/tweets/#{@tweet.id}"
        else
          redirect to "/tweets/#{@tweet.id}/edit"
        end
      else
        redirect to '/tweets'
      end
    end
  else
    redirect to '/login'
  end
end

delete '/tweets/:id/delete' do
  if logged_in?
    @tweet = Tweet.find_by_id(params[:id])
    if @tweet && @tweet.user == current_user
@weezwo
weezwo on Jun 14, 2018
Prefer to find tweets that are already only associated to the current_user than to manually check the user_id foreign key of the tweet against the current_user.id

tweet = current_user.tweets.find_by(id: params[:id])
if tweet && tweet.destroy
redirect "/tweets"
else
redirect "/tweets/#{tweet.id}"
end
We're using the association collection method provided by has_many to query the user's tweets.

Note the usage of find_by vs find. Had we used find here, ActiveRecord would raise an error in the event that we could not find a tweet associated with this user. find_by will allow this action to fail gracefully, simply returning nil if the user is trying to delete a tweet that they do not have access to.

@DahliaBloomstone	Reply…
      @tweet.delete
    end
    redirect to '/tweets'
  else
    redirect to '/login'
  end
end
end
