Mail.defaults do
  delivery_method :smtp, { :address              => 'smtp.qiye.163.com',
                           :domain               => 'qq.com',
                           :user_name            => 'john.zhao@i-click.cn',
                           :password             => '!@#qwe123',
                           :authentication       => :login,
                           :enable_starttls_auto => true
                        }
end

module Mailer
  
  module InstanceMethods
    def send_mail(params={})
      receivers = ['363602094@qq.com']
      subject_info = "download mail"
      body_info    = "voa download mail"

      Mail.deliver do
         from    'john.zhao@i-click.cn'
         to      params['to'] || receivers
         subject params['subject'] || subject_info
         body    params['body'] || body_info
      end
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end
