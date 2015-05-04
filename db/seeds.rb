# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
#

tutorials = [
  [
    author: "mary",
    slug: "connect-via-ssh-mac",
    title: "Connect via SSH (Mac)",
    content_markdown: "#filler",
    content_html: "<h3>Generate a new SSH key</h3>
    <p>This is seeded data. On your personal computer (i.e. not on your Nitrous box) enter the code below. We want the default settings so when asked to enter a file in which to save the key, just press enter.
    <pre><code class='prettyprint'>
ssh-keygen -t rsa -C 
# Creates a new ssh key using the provided email
#
# # Generating public/private rsa key pair.
# # Enter file in which to save the key (/Users/you/.ssh/id_rsa): [Press enter]
    </code></pre></p>
    <p>Enter a passphrase (passphrases make things more secure).</p>
    <pre><code class='prettyprint'>
# Enter passphrase (empty for no passphrase): [Type a passphrase]
# # Enter same passphrase again: [Type passphrase again]
# Which should give you something like this:
#
# # Your identification has been saved in /Users/you/.ssh/id_rsa.
# # Your public key has been saved in /Users/you/.ssh/id_rsa.pub.
# # The key fingerprint is:
# # 01:0f:f4:3b:ca:85:d6:17:a1:7d:f0:68:9d:f0:a2:db your_email@youremail.com
    </code></pre>
    <h3>Add your SSH key to Nitrous</h3>
    <p>Run the following code to copy the key to your clipboard.</p>",
    tag_list: "rails, ruby",
  ],
  [ 
    author: "john",
    slug: "preview-your-app",
    title: "Preview Your App",
    content_markdown: "#filler",
    content_html: "<h3>Preview your app</h3><p>This is seeded data. Once you have built and configured your app you are ready for previewing. If you selected a stack template then you can preview the app immediately.</p><p>For this example we will assume you have selected a Ruby on Rails stack template. Within the console, navigate into your project folder and run the Rails server.</p><pre><code class='prettyprint'>
$ cd ~/code/starter
$ rails server -b 0.0.0.0
    </pre></code>
    <p>In the console you will see the Rails app start up on 0.0.0.0:3000.</p>",
    tag_list: "rails, scala",
  ],
  [ 
    author: "john",
    slug: "web-ide-overview",
    title: "Web IDE Overview",
    content_markdown: "#filler",
    content_html: "<p>The IDE is a powerful, one stop shop for (almost) all of your development needs.</p><h3>File Browser</h3><p>Like most IDEs, the file browser sits at the left-hand side of the window. You'll see the box-name at the top of the file browser, followed by a directory tree of your application.</p><p>Like most IDEs, the file browser sits at the left-hand side of the window. You'll see the box-name at the top of the file browser, followed by a directory tree of your application.</p>",
    tag_list: "ruby, IDE",
  ],

]

tutorials.each do |tutorial|
  Tutorial.create(tutorial)
end
