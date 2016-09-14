These files are required for MTBWI.
Currently mtbwi is configured to expect these file to reside in
/usr/local/mgi/mtb/live/www/...

The file index.html has a hard coded url that includes the server name.
This needs to be configured to correctly match the deployment of MTB.

The file mtbwi.properties has a number of urls in it that need to match
the url where a given instance of MTBWI is deployed.
mtbwi.properties also includes a database connection string. 
This string needs to correspond to the database to be used by MTBWI instance.