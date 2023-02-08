use std::{env, thread, time};
use nix::unistd;

fn main() {
    let args: Vec<String> = env::args().collect();

    for element in &args[1..] {
        let element_div: Vec<&str> = element.split(":").collect();

        let dir: &str = &format!("/{}", element_div[0])[..];
        print!("{} - ", dir);

        let uid: u32 = element_div[1].parse::<u32>().expect("Invalid UID");
        let gid: u32 = element_div[2].parse::<u32>().expect("Invalid GID");

        unistd::chown(
            dir,
            Some(uid.into()),
            Some(gid.into()),
        ).expect("Unable to chown");
        println!("Set UID {}, GID {}", uid, gid);
    }

    println!("Done");
    let sleep_time = time::Duration::from_secs(60);
    loop {thread::sleep(sleep_time);}
}