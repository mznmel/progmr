class User < ActiveRecord::Base
  has_secure_password

  # Only allow setting these values on create
  attr_readonly :username

  # These values can be changed anytime
  attr_accessible :email, :username, :password, :password_confirmation

  # Validations
  validates :username, :presence => true,
            :length => { :in => 4..25 },
            :format => { :with => /^[a-zA-Z0-9_]+$/u },
            :uniqueness => { :case_sensitive => false },
            :exclusion => { :in => %w(
            inbox wall home signup doSignup login logout profile updateProfile home wall w
            postQuestion postAnswer tag tags showQuestion
            forgottenPassword sendPasswordResets passwordResets doPasswordResets
            doLogin about aboutus account accounts add admin administer administrator admins
            ajax anon anonymous apache api app apps archive archives article articles auth
            authenticate authentication author backup better blog blogger cache careers
            cart changelog checkout client clients codereview compare config configuration
            connect contact contactus contributor cpanel create css daemon data database
            deal deals delete director direct_messages docs documentation download downloads
            edit editor email emailus employment enterprise explore facebook faq faqs
            favorites feed feeds fleet fleets follow followers following font fonts forum
            forums friend friends friending ftpuser games gist group groups guest help host
            hosting hostmaster http httpd idea ideas image images include includes index
            indexes info invitation invitations invite is it job jobs json lib library list
            lists login logout logs mail map maps master mine mis misc miscellaneous
            moderate moderator module modules mysql news nobody node nodes oauth
            oauth_clients offers office openid operate operator oracle order orders
            organizations owner password passwords plans poll polls popular post postgres
            postmaster president privacy profile profiles projects public put pwnd pwned
            pwnage question questions qwerty rdf recruit recruiter recruiters recruitment
            register registrar registration remove replies root rss sales save save script
            scripts search security server service sessions settings shell shop signout
            sitemap spam ssl ssladmin ssladministrator sslwebmaster stat stats statistics
            status stories student styleguide subscribe support supporter survey surveys
            sysadmin template templates terms test tester testing tests testuser theme
            themes tour tomcat translations trends tutorial tutorials twitter twittr
            unfollow unsubscribe url update upload uploads user users video videos
            weather webadmin webmaster widget widgets wiki www wwww xfn xmpp yml yaml
            ) }

  validates :email, :presence => true,
            :uniqueness => {:case_sensitive => false},
            :format => { :with => /^.+@.+$/ }

  validates :password, :presence => true,
            :length => {:within => 5..25},
            :on => :create

  validates :password, :confirmation => true,
            :length => {:within => 5..25},
            :allow_blank => true,
            :on => :update
end