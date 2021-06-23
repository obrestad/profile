# Installs the weechat client 
class profile::clients::weechat {
  package { [
    'weechat',
    'weechat-curses',
    'weechat-plugins',
  ]:
    ensure  => 'present',
  }
}
