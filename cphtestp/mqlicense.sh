#!/bin/bash
LAP_JAR=LAPApp.jar
MQVRMF=9.2.3.0
BUILD_PLATFORM=Linux_x86_64
UNAME_FLAG=-i
#############################################################################
#
#   <copyright
#   notice="lm-source-program"
#   pids="5724-H72"
#   years="2005,2020"
#   crc="3544123140" >
#   Licensed Materials - Property of IBM
#
#   5724-H72
#
#   (C) Copyright IBM Corp. 2005, 2020 All Rights Reserved.
#
#   US Government Users Restricted Rights - Use, duplication or
#   disclosure restricted by GSA ADP Schedule Contract with
#   IBM Corp.
#   </copyright>
#
#
# NAME: mqlicense
#
# PURPOSE: Launch Java License Agreement Process tool
#
#############################################################################

#############################################################################
#  Change these values to match the required SOE
#############################################################################
typeset -i MIN_SLES_VERSION=12
typeset -i MIN_SLES_RELEASE=2
typeset -i MIN_RH_VERSION=7
typeset -i MIN_RH_RELEASE=2
typeset -i MIN_UBUNTU_VERSION=16
#  Note:  This does not need to be integer as it is not used for numeric comparison
#         and will almost certainly always be 04 as that is the Ubuntu LTS release.
MIN_UBUNTU_RELEASE=04

#############################################################################

PROGNAME=`basename $0`         # Program name
PROGPATH=`dirname $0`          # Working directory

#-----------------------------------------------------------------------#


# Display command syntax
usage ()
{
    echo "Usage: ${PROGNAME?} [-accept] [-text_only] [ -jre ( path_to_java | \"path_to_java java_options\" ) ] ][-h|-?]"
}

declinemsg()
{
cat << +++EOM+++

Agreement declined:  The license agreement must be accepted
before using IBM MQ.

+++EOM+++
}

copyright()
{
if [ -f $PROGPATH/copyright ] ; then
     cat $PROGPATH/copyright
fi
}

errormsg()
{
cat << +++EOM+++

ERROR:  You cannot use IBM MQ unless the license
        agreement can be accepted.

        If the error was caused by a display problem,
        read the license agreement file  (Lic_xx.txt, where
        xx represents your language ) in the 'licenses'
        directory of the installation media, and then
	run the following command:

            ${PROGNAME?} -accept

        Only use this command if you accept the license
        agreement.

        For other errors, contact your IBM support centre.

+++EOM+++
}


#-----------------------------------------------------------------------#
#                             Main program
#-----------------------------------------------------------------------#
typeset -i RH_Version
typeset -i RH_Release
typeset -i SUSE_Version
typeset -i Ubuntu_Version
OS_Warn=no
#-----------------------------------------------------------------------#
# Set umask so that chckinstall script can read files in tmp            #
# needed on Solaris where checkinstall/request scripts run as nobody    #
#-----------------------------------------------------------------------#
umask 022

# Script must be run as root
id | grep "uid=0" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR:  You must be 'root' to run this script."
    exit 1
fi

copyright

if [ ${BUILD_PLATFORM} != `uname`_`eval "uname ${UNAME_FLAG}"` ]
  then
    echo "ERROR: This package is incompatible with this system."
    echo "       This package was built for ${BUILD_PLATFORM}"
    echo ""
    exit 1
fi


if [ `uname` = 'Linux' ] ; then
  if [ -x /usr/bin/lsb_release ] ; then
    lsb_release_out=`/usr/bin/lsb_release -s -i 2>&1 | grep SUSE`
    if [ $? -eq 0 ] ; then
      SUSE_Version=`/usr/bin/lsb_release -s -r | awk -F. '{print $1}'`
      SUSE_NUM_FIELDS=`/usr/bin/lsb_release -s -r | awk -F. '{print NF}'`
      if [ ${SUSE_NUM_FIELDS} -eq  1 ] ;then
        SUSE_Release=0
      else
        SUSE_Release=`/usr/bin/lsb_release -s -r | awk -F. '{print $2}'`
      fi
      if [ ${SUSE_Version} -lt ${MIN_SLES_VERSION} ] ; then
        echo ""
        echo "WARNING: This package is incompatible with this system."
        echo "         For SUSE systems, Version should be ${MIN_SLES_VERSION}.${MIN_SLES_RELEASE} or later."
        echo ""
        OS_Warn=yes
      else
        if [ ${SUSE_Version} -eq ${MIN_SLES_VERSION} ] ; then
          if [ ${SUSE_Release} -lt ${MIN_SLES_RELEASE} ] ; then
            echo ""
            echo "WARNING: This package is incompatible with this system."
            echo "         For SUSE systems, Version should be ${MIN_SLES_VERSION}.${MIN_SLES_RELEASE} or later."
            echo ""
            OS_Warn=yes
          fi
        fi
      fi
    else
      lsb_release_out=`/usr/bin/lsb_release -s -i 2>&1 | grep -i redhat`
      if [ $? -eq 0 ] ; then
        RH_Version=`/usr/bin/lsb_release -s -r | cut -f1 -d'.'`
        RH_Release=`/usr/bin/lsb_release -s -r | cut -f2 -d'.'`
        if [ ${RH_Version} -lt ${MIN_RH_VERSION} ] ; then
          echo ""
          echo "WARNING: This package is incompatible with this system."
          echo "         For Red Hat systems, Version should be ${MIN_RH_VERSION}.${MIN_RH_RELEASE} or later."
          echo ""
          OS_Warn=yes
        else if [ ${RH_Version} -eq  ${MIN_RH_VERSION} ] && [  ${RH_Release} -lt  ${MIN_RH_RELEASE} ] ; then
          echo ""
          echo "WARNING: This package is incompatible with this system."
          echo "         For Red Hat systems, Version should be ${MIN_RH_VERSION}.${MIN_RH_RELEASE} or later."
          echo ""
          OS_Warn=yes
        fi
        fi
      else
        lsb_release_out=`/usr/bin/lsb_release -s -i 2>&1 | grep -i Ubuntu`
        if [ $? -eq 0 ] ; then
          Ubuntu_Version=`/usr/bin/lsb_release -s -r | cut -f1 -d'.'`
          if [ ${Ubuntu_Version} -lt ${MIN_UBUNTU_VERSION} ] ; then
            echo ""
            echo "ERROR: This package is incompatible with this system."
            echo "       For Ubuntu systems, Version must be ${MIN_UBUNTU_VERSION}.${MIN_UBUNTU_RELEASE} or later."
            echo ""
            OS_Warn=yes
          fi
        fi
      fi
    fi
  else
    # try another approach...
    if [ -e /etc/os-release ] ; then
      . /etc/os-release
      if [ ${ID} = "rhel" ] ; then
        RH_Version=`echo ${VERSION_ID} | cut -f1 -d'.'`
        RH_Release=`echo ${VERSION_ID} | cut -f2 -d'.'`
        if [ ${RH_Version} -lt ${MIN_RH_VERSION} ] ; then
          echo ""
          echo "WARNING: This package is incompatible with this system."
          echo "         For Red Hat systems, Version should be ${MIN_RH_VERSION}.${MIN_RH_RELEASE} or later."
          echo ""
          OS_Warn=yes
        else
          if [ ${RH_Version} -eq ${MIN_RH_VERSION} ] && [  ${RH_Release} -lt ${MIN_RH_RELEASE} ] ; then
            echo ""
            echo "WARNING: This package is incompatible with this system."
            echo "         For Red Hat systems, Version should be ${MIN_RH_VERSION}.${MIN_RH_RELEASE} or later."
            echo ""
            OS_Warn=yes
          fi
        fi
      else
        if [ ${ID} = "ubuntu" ] ; then
          Ubuntu_Version=`echo ${VERSION_ID} | cut -f1 -d'.'`
          if [ ${Ubuntu_Version} -lt  ${MIN_UBUNTU_VERSION} ] ; then
            echo ""
            echo "ERROR: This package is incompatible with this system."
            echo "       For Ubuntu systems, Version must be ${MIN_UBUNTU_VERSION}.${MIN_UBUNTU_RELEASE} or later."
            echo ""
            OS_Warn=yes
          fi
        else
          if [ ${ID} = "sles" ] ; then
            Sles_Version=`echo ${VERSION_ID} | cut -f1 -d'.'`
            Sles_Num_Fields=`echo ${VERSION_ID} | awk -F. '{print NF}'`
            if [ ${Sles_Num_Fields} -eq 1 ] ; then
              Sles_Release=0
            else
              Sles_Release=`echo ${VERSION_ID} | awk -F. '{print $2}'`
            fi
            if [ ${Sles_Version} -lt ${MIN_SLES_VERSION} ] ; then
              echo " "
              echo "ERROR: This package is incompatible with this system."
              echo "       For SUSE systems, Version must be ${MIN_SLES_VERSION}.${MIN_SLES_RELEASE} or later."
              echo ""
              OS_Warn=yes
            else
              if [ ${Sles_Version} -eq ${MIN_SLES_VERSION} ] ; then
                if [ ${Sles_Release} -eq ${MIN_SLES_RELEASE} ] ; then
                  echo " "
                  echo "ERROR: This package is incompatible with this system."
                  echo "       For SUSE systems, Version must be ${MIN_SLES_VERSION}.${MIN_SLES_RELEASE} or later."
                  echo " "
                  OS_Warn=yes
                fi
              fi
            fi
          else
              echo " "
              echo "WARNING: Unable to determine distribution and release for this system. "
              echo "         Check that it is supported before continuing with installation."
              echo " "
          fi
        fi
      fi
    else
      echo " "
      echo "WARNING: Unable to determine distribution and release for this system. "
      echo "         Check that it is supported before continuing with installation."
      echo " "
    fi
  fi
fi


# Process command-line
#The following condition works correctly in bash, dash, and ksh
#Alternatively, could use ## while [ "$(echo $1 | cut -c1)" = "-" ] ##
while [ "${1%%[!-]*}" = "-" ]
do
    case $1 in
        "-accept")
            STATUSARG="-t 5"         ;;
        "-text_only")
            DISPLAYARG="-text_only"  ;;
        "-jre")
            LAPJRE=$2
            USER_DEFINED_JRE="true"
            shift                    ;;
        "-h" | "-?")
            usage; exit 0            ;;
        *)
            usage; exit 1            ;;
    esac
    shift
done


# Work out package release - required for /tmp license location
  MQVRM=`echo ${MQVRMF} | awk -F. '{print $1"."$2"."$3}'`

# Check whether the license has already been accepted
if [ -r /tmp/mq_license_${MQVRM}/license/status.dat ]; then
   if [ ${OS_Warn} = 'yes' ] ; then
     echo "License has already been accepted:  Warning(s) issued, see messages above."
   else
     echo "License has already been accepted:  Proceed with install."
   fi
   echo ""
   exit 0
fi


# Set JRE location
LAPJRE="${LAPJRE:-$(find $PROGPATH/lap -type d -name bin)/java}"
if [ ! -x "${LAPJRE}" ]; then

  if [ "${USER_DEFINED_JRE}" = "true" ]; then
    # The user specified a JRE which cannot be found/executed
    echo "ERROR: No executable Java program found at the specified -jre location: \"${LAPJRE}\""
    echo ""
    errormsg
    exit 1
  fi

  # If the installation image has been copied from one location to another, then
  # the file permissions may have been altered such that 'java' is no longer
  # executable.  Output an informative message if this is the case.
  if [ ! -f "${LAPJRE}" ]; then
    # There is no 'java' binary,
    echo "ERROR: Unable to locate the Java binary required by this license acceptance"
    echo "       script.  Check that the installation media has been correctly extracted."
    echo ""
    errormsg
    exit 1
  else
    # There is a 'java' file, but it cannot be executed.
    echo "ERROR: Unable to execute the Java binary located on the filesystem at:"
    echo "       \"${LAPJRE}\""
    echo "       Check that the installation media is suitable for the system"
    echo "       architecture, and check that the permissions of the installation files"
    echo "       match that contained within the original installation media."
    echo ""
    errormsg
    exit 1
  fi
fi


# Set classpath
LAPCLASSPATH=${PROGPATH?}/lap/${LAP_JAR}:${PROGPATH?}/lap/jre/lib/rt.jar:${PROGPATH?}/lap/jre/lib/i18n.jar

# Record the hardware architecture type
HARDWARE_ARCH=`eval "uname ${UNAME_FLAG}"`

# Check for graphics (if required)
if [ \( -z "${STATUSARG}" \) -a \( -z "${DISPLAYARG}" \) ]; then

    # When "xset -q" is run on a ppc Linux box exporting the display to a x86
    # box, the command hangs.  Therefore use xdpyinfo on ppc
    if [ "$uname" = "Linux" ] ; then
      CHECK_X_CMD="xdpyinfo"
    else
      CHECK_X_CMD="xset -q"
    fi
    ${CHECK_X_CMD} > /dev/null 2>&1

    # Default to text mode if there were any errors
    if [ $? -ne 0 ]; then
        DISPLAYARG="-text_only"
    elif [ ! -z "${DISPLAY}" ]; then
        echo "Displaying license agreement on ${DISPLAY}"
    fi

fi

# RedHat AS 3 does not install a c++ compatible library by default, which is
# needed by the JRE on Linux zSeries (compat-libstdc++-7.2-2.95.3.80.s390.rpm
# in RHEL AS 3 on zSeries).  This is overcome by turning off the jitc compiler
# using an environment variable.
output=$(echo $HARDWARE_ARCH | grep s390)
if [ $? -eq 0 ] ; then
  export JAVA_COMPILER=NONE
fi

# Launch LAP tool
${LAPJRE?} -cp ${LAPCLASSPATH?} com.ibm.lex.lapapp.LAP -l ${PROGPATH?}/lap/licenses -s /tmp/mq_license_${MQVRM} ${STATUSARG} ${DISPLAYARG}
RC=$?


# Display appropriate completion message depending on LAP return code
case ${RC?} in
    "3")
        declinemsg                                                     ;;
    "9")
        echo ""
        if [ ${OS_Warn} = 'yes' ] ; then
          echo "Agreement accepted:  Warning(s) issued, see messages above."
        else
           echo "Agreement accepted:  Proceed with install."
        fi
        echo ""                                                        ;;
    *)
        errormsg; exit ${RC}                                           ;;
esac
