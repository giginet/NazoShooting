====================
謎シューティング！
====================

.. image:: https://github.com/giginet/NazoShooting/raw/master/ss.jpg


謎シューティングは札幌ゲーム制作者コミュニティKawazで2010年4月に行われた、
春のシューティング祭りで開発された物です。

ゲーム自体は@giginetがゼビウス、ドラゴンスピリット、ツインビー、ロックマンに影響を受けて開発されました。

====================
Instration
====================

Install Ruby1.8.7 via Ruby Version Manager
--------------

::
  
  bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
  source ~/.bash_profile
  rvm requirements
  rvm install 1.8.7
  rvm use 1.8.7

Install SDL Libraries via Homebrew
------------------

::

  brew install sdl, sdl_image, sdl_mixer, sdl_ttf


Install rsdl via Rubygems
------------------

::

  gem install rsdl


Install rubysdl via source file.
----------------------

http://rubyforge.org/frs/?group_id=1006

Install rubysdl (latest version).



Run 'NazoShooting'
------------------------

::

  rsdl main.rb

