class User < ActiveRecord::Base
  has_one :favorite, :dependent => :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable
  validates :email, :uniqueness => true, :presence => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :name, :gender, :age, :phone, :companyName, :presence => true
  before_save :ensure_authentication_token

  def set_password
    self.generated_password = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
    self.password = generated_password
    self.confirm!
    self.save
  end

  def ensure_authentication_token
    self.token = (0...30).map { ('a'..'z').to_a[rand(26)] }.join
  end

end
# registration   GET https://localhost:3000/api/v1/user
#  email=admin@mail.ru&name=Andriy&gender=male&age=38&phone=384254235&companyName=Melbourhgn LLC&profession=plumber

# sign_in   POST https://localhost:3000/api/v1/sessions   email=admin@mail.ru&password=ppcivodt
# sign_in   POST https://ruby-news-server.herokuapp.com/api/v1/sessions   email=admin6@mail.ru&password=llsorpsd

# sign_out   DELETE https://localhost:3000/api/v1/sessions/

#  ask a single article GET  https://localhost:3000/articles/1?shouldReturnContent=true

#  create article POST https://localhost:3000/articles
#  stockMarketName=Melbourgn&name=Melbourgn LLC Sanders Future Company&title=observers found new star&body=some body&date=2014-04-29&region=Asia&links[]=deal_http://some_url.com&links[]=source_http://some_url_last.com&shouldReturnContent=true

#  ask articles GET  https://localhost:3000/articles?pageIndex=1&countPerPage=10&start=2014-05-01&end=2014-05-13&region=1&shouldReturnContent=true

#  mark article as favorite PUT  https://localhost:3000/articles/1
#  shouldReturnContent=true&isFavorite=true