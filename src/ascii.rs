use os_info::Info;

pub fn get_ascii_art(os: &Info) -> &'static str {
    let name = os.os_type().to_string().to_lowercase();
    if name.contains("ubuntu") {
        UBUNTU_ASCII
    } else if name.contains("debian") {
        DEBIAN_ASCII
    } else if name.contains("arch") {
        ARCH_ASCII
    } else if name.contains("void") {
        VOID_ASCII
    } else if name.contains("opensuse") {
        OPENSUSE_ASCII
    } else {
        GENERIC_ASCII
    }
}

const GENERIC_ASCII: &str = r#"
 _          _   _             __      _       _
| |__   ___| |_| |_ ___ _ __ / _| ___| |_ ___| |__
| '_ \ / _ \ __| __/ _ \ '__| |_ / _ \ __/ __| '_ \
| |_) |  __/ |_| ||  __/ |  |  _|  __/ || (__| | | |
|_.__/ \___|\__|\__\___|_|  |_|  \___|\__\___|_| |_|

"#;

const UBUNTU_ASCII: &str = r#"
         _
     ---(_)
 _/  ---  \
(_) |   |
  \  --- _/
     ---(_)

"#;

const DEBIAN_ASCII: &str = r#"
  _____
 /  __ \
|  /    |
|  \___-
 -_
   --_

"#;

const ARCH_ASCII: &str = r#"
       /\
      /  \
     /\   \
    /      \
   /   ,,   \
  /   |  |  -\
 /_-''    ''-_\

"#;

const VOID_ASCII: &str = r#"
    _______
 _ \______ -
| \  ___  \ |
| | /   \ | |
| | \___/ | |
| \______ \_|
 -_______\

"#;

const OPENSUSE_ASCII: &str = r#"
  _______
__|   __ \
     / .\
     \__/ |
   _______|
   \_______
  __________\

"#;
