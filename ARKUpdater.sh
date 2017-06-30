// update ARK
//
@ShutdownOnFailedCommand 1 //set to 0 if updating multiple servers at once
@NoPromptForPassword 1
//login <username> <password>
//for servers which don't need a login
login anonymous 
force_install_dir /home/steam/Ark_server
app_update 376030 validate
quit

// crontab entry:
// 0 4 * * * /home/steam/Steam/steamcmd.sh +runscript /home/steam/scripts/ARKUpdater.sh
