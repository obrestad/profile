# Installs the weechat client 
class profile::clients::weechat {
  package { [
    'weechat',
    'weechat-curses',
    'weechat-plugin',
  ]:
    ensure  => 'present',
  }
}
