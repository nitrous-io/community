desc 'Popluate posts/tutorials for test'
task :populate_test_data => :environment do
  _do = %w(Deploy Configure Encrypt Run)

  _framework = ["ASP.NET MVC Framework","ASP.NET Dynamic Data","Base One Foundation Component Library","Component-based Scalable Logical Architecture","MonoRail","OpenRasta","License","Saetta Web Server","License","CppCMS","Poco","Tntnet","Wt","License","CFWheels","ColdBox Platform","ColdSpring","Fusebox","Mach-II","Model-Glue","License","vibe.d","License","Happstack","Snap","Yesod","License","Apache Click","Apache OFBiz","Apache Shale","Apache Sling","Apache Struts 2","Apache Tapestry","Apache Wicket","AppFuse","Brutos Framework","Eclipse RAP","FormEngine","Grails","Google Web Toolkit","Hamlets","ItsNat","JavaServer Faces","JBoss Seam","Jspx-bay","JVx","OpenLaszlo","OpenXava","Oracle ADF","Play","RIFE","Spark","Spring","Stripes","Takes","ThinWire","Vaadin","VRaptor","Wavemaker","WebObjects","WebWork","Ze Framework","ZK","ztemplates","License","License","Play!","Lift","Scalatra","License","Catalyst","Dancer","Mason","Maypole","Mojolicious","License","Agavi","Aiki Framework","Ayoola Framework","CakePHP","Cgiapp","ClanCatsFramework","CodeIgniter","Fat-Free","FuelPHP","Hazaar MVC","Kajona","Laravel","Lithium","Nette Framework","Phalcon","PHPixie","PRADO","Qcodo","Seagull","Silex","Symfony","TYPO3 Flow","Xyster Framework","Yii","Zend Framework","License","BlueBream","CherryPy","CubicWeb","Django","Flask","Grok","Nagare","Pyjamas","Pylons","Pyramid","TACTIC","Tornado","TurboGears","web2py","Webware","Zope 2","License","Camping","Padrino","Ruby on Rails","Sinatra","Merb","PureMVC","Language","License","AIDA/Web","Application Express","AWS","Compojure","Flex","Grails","Kepler","Morfik","Ocsigen","Opa","OpenACS","Seaside","Zotonic","Ajax","MVC","MVC push-pull","i18n & L10n?","ORM","DB migration","CppCMS","Tntnet","Wt","Ajax","MVC","MVC push-pull","i18n & L10n?","ORM","DB migration","ColdBox Platform","ColdFusion on Wheels","Fusebox","Mach-II","Model-Glue","Ajax","MVC","MVC push-pull","i18n & L10n?","ORM","DB migration","Apache Click","Apache OFBiz","Apache Sling","Apache Struts","Apache Tapestry","Apache Wicket","FormEngine","Grails","ItsNat","JavaServer Faces","Ajax","MVC","MVC push-pull","i18n & L10n?","ORM","DB migration","JBoss Seam","Jspx-bay","JVx WebUI","OpenXava","Play","RIFE","Spring","Stripes","Vaadin","Wavemaker","Ajax","MVC","MVC push-pull","i18n & L10n?","ORM","DB migration","WebObjects","ztemplates","Google Web Toolkit","ZK","Ajax","MVC","MVC push-pull","i18n & L10n?","ORM","DB migration","AngularJS","EmberJS","qooxdoo","SproutCore","Wakanda","Ajax","MVC","MVC push-pull","i18n & L10n?","ORM","DB migration","Catalyst","Dancer","Mason","Maypole","Mojolicious","Ajax","MVC","MVC push-pull","i18n & L10n?","ORM","DB migration","Scaffolding","RAD","CakePHP 1 & 2","CakePHP 3","ClanCatsFramework","CodeIgniter","Drupal","Fat-Free Framework","FuelPHP","Fusebox","Joomla","Lithium","Nette Framework","PRADO","Qcodo","SilverStripe","Solodev CMS","Symfony","Symfony 2","Yii","Zend Framework","[50]","Zend Framework 2","Zikula","Ajax","MVC","MVC push-pull","i18n & L10n?","ORM","DB migration","CherryPy","Django","Pyjamas","Pylons","Pyramid","TACTIC","Tornado","TurboGears","web2py","Webware","BlueBream","Zope","Ajax","MVC","MVC push-pull","i18n & L10n?","ORM","DB migration","Camping","Ruby on Rails","Sinatra","Ajax","MVC","MVC push-pull","i18n & L10n?","ORM","DB migration","AIDA/Web","Application Express","Flex","Kepler","Lift","Ocsigen","Opa","OpenACS","Seaside","DB migration"]

  _os = ["Ubuntu", "Fedora", "Window", "DOS", "MacOS"]

  User.where(id: 99999).destroy_all
  Post.destroy_all
  Tutorial.destroy_all
  user = User.create(id: 99999, username: 'admin', email: 'admin+9000@nitrous.io', admin: true, last_fetched_at: Time.now)

  count = 0
  _do.each do |d|
    _framework.each do |f|
      _os.each do |o|
        title = "How To #{d} #{f} On #{o}"
        content = "How To #{d} #{f} On #{o}"
        tags = [f, o]

        if count % 3 == 0
          Post.create(user: user, title: title, content_markdown: content, tag_list: tags.join(','))
          Tutorial.create(user: user, title: title, content_markdown: content, tag_list: tags.join(','))
        else
          Post.create(user: user, title: title, content_markdown: content, tag_list: tags.join(','), state: :published, published_at: Time.now)
          Tutorial.create(user: user, title: title, content_markdown: content, tag_list: tags.join(','), state: :published, published_at: Time.now)
        end
        count += 1
      end
    end
  end
end