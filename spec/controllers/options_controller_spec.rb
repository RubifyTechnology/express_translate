# describe RubifyLanguages::OptionsController do
#
#   describe "Get index" do
#     it "returns a list of packages" do
#       get 'index'
#       response.should be_success
#     end
#
#     it "returns Ruby comment only if query search string is Ruby" do
#       get 'index', q: 'ruby'
#       response.should be_success
#
#       comments = json(response.body)
#       contents = comments.collect{|c| c[:content]}
#       contents.should include("Ruby")
#       contents.should_not include("Rails")
#     end
#
#     it "returns a comment by its id" do
#       get 'show', id: @comment_a.id
#       response.should be_success
#
#       comment = json(response.body)
#       comment[:content].should == @comment_a.content
#     end
#
#   end
#
# end
#
#