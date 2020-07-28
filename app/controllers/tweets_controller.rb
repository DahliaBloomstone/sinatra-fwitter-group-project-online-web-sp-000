class TweetsController < ApplicationController

  get '/tweets' do
         if logged_in?(session)
             @user = current_user(session)
             @tweets = Tweet.all
             @users = User.all
         else
             redirect to "/login"
         end
         erb :'tweets/tweets'
     end

     get '/tweets/new' do
         if logged_in?(session)
             erb :'tweets/create_tweet'
         else
             redirect to "/login"
         end
     end

     post '/tweets' do
         @tweet = Tweet.new(params)
  @cernanb
 cernanb on Aug 4, 2017
 The tweet creation and user association can both be accomplished in the same step:

 @tweet = Tweet.create(content: params[:content], user: current_user)
 @DahliaBloomstone	Reply…

         if @tweet.content == ""
  @cernanb
 cernanb on Aug 4, 2017
 I think you could use ActiveRecord validations (e.g. validates_presence_of :username) to perform these types of checks more easily.

 @DahliaBloomstone	Reply…
             redirect to "/tweets/new"
         elsif @tweet.save
             @user = current_user(session)
             @user.tweets << @tweet
             redirect to "/tweets"
          else
             redirect to "/signup"
         end
     end

     get '/tweets/:id' do
         if logged_in?(session)
             @tweet = current_tweet(params[:id])
             erb :'tweets/show_tweet'
         else
             redirect to "/login"
         end
     end

     get '/tweets/:id/edit' do
         if logged_in?(session)
             @tweet = current_tweet(params[:id])
  @cernanb
 cernanb on Aug 4, 2017
 Shouldn't you verify a tweet belongs to the current_user (and not just that any user is logged in) before allowing them to edit?

 @DahliaBloomstone	Reply…
             erb :'tweets/show_tweet'
         else
             redirect to "/login"
         end
     end

     patch '/tweets/:id' do
         @tweet = current_tweet(params[:id])
         @user = current_user(session)
         if @tweet.user_id == @user.id
             if params["content"] != ""
                 @tweet.content = params["content"]
                 @tweet.save
                 flash[:message] = "Successfully updated tweet."
                 redirect to "/tweets/#{@tweet.id}/edit"
             else
                 flash[:message] = "Your tweet cannot be empty."
                 redirect to "/tweets/#{@tweet.id}/edit"
             end
         else
             flash[:message] = "You can only edit and delete your own tweets"
             redirect to "/tweets"
         end
     end

     delete '/tweets/:id' do
         if logged_in?(session)
             @user = current_user(session)
             @tweet = current_tweet(params[:id])
  @cernanb
 cernanb on Aug 4, 2017
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
             if @tweet.user_id == @user.id
                 @tweet.delete
                 redirect to '/tweets'
             else
                 redirect to "/tweets"
             end
         end
     end
 end
