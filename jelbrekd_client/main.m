//
//  jelbrekd_client.m
//  jelbrekd_client
//
//  Created by Tanay Findley on 4/21/19.
//  Copyright © 2019 Tanay Findley. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include "libjailbreak_mig.h"

void logMe(const char *message)
{
    fprintf(stderr, "%s", message);
}

int main(int argc, char **argv, char **envp) {
    if (argc < 3){
        logMe("Usage: \n");
        logMe("jelbrekd_client <pid> <1 | 2 | 6>\n");
        logMe("\t1 = entitle+platformize the target PID\n");
        logMe("\t2 = entitle+platformize the target PID and subsequently sent SIGCONT\n");
        logMe("\t6 = fixup setuid in the target PID\n");
        return 0;
    }
    if (atoi(argv[2]) != 1 && atoi(argv[2]) != 2 && atoi(argv[2]) != 5 && atoi(argv[2]) != 6){
        logMe("Usage: \n");
        logMe("jailbreakd_client <pid> <1 | 2 | 6>\n");
        logMe("\t1 = entitle the target PID\n");
        logMe("\t2 = entitle+platformize the target PID and subsequently sent SIGCONT\n");
        logMe("\t6 = fixup setuid in the target PID\n");
        return 0;
    }
    
    jb_connection_t jbc = jb_connect();
    
    pid_t pid = atoi(argv[1]);
    int arg = atoi(argv[2]);
    int ret = 0;
    
    if (arg == 1) {
        ret = jb_entitle_now(jbc, pid, 7 | FLAG_WAIT_EXEC);
    } else if (arg == 2) {
        ret = jb_entitle_now(jbc, pid, 15);
    } else if (arg == 6) {
        ret = jb_fix_setuid_now(jbc, pid);
    }
    jb_disconnect(jbc);
    return ret;
}
