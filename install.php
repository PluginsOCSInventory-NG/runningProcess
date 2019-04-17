<?php

/**
 * This function is called on installation and is used to create database schema for the plugin
 */
function extension_install_runningprocess()
{
    $commonObject = new ExtensionCommon;

    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `runningprocess` (
                              `ID` INT(11) NOT NULL AUTO_INCREMENT,
                              `HARDWARE_ID` INT(11) NOT NULL,
                              `CPUUSAGE` VARCHAR(255) DEFAULT NULL,
                              `TTY` VARCHAR(255) DEFAULT NULL,
                              `STARTED` VARCHAR(15) DEFAULT NULL,
                              `VIRTUALMEMORY` VARCHAR(255) DEFAULT NULL,
                              `PROCESSNAME` VARCHAR(255) DEFAULT NULL,
                              `PROCESSID` VARCHAR(255) DEFAULT NULL,
                              `USERNAME` VARCHAR(255) DEFAULT NULL,
                              `PROCESSMEMORY` VARCHAR(255) DEFAULT NULL,
                              `COMMANDLINE` VARCHAR(255) DEFAULT NULL,
                              `DESCRIPTION` VARCHAR(255) DEFAULT NULL,
                              `COMPANY` VARCHAR(255) DEFAULT NULL,
                              PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                              ) ENGINE=INNODB;");
}

/**
 * This function is called on removal and is used to destroy database schema for the plugin
 */
function extension_delete_runningprocess()
{
    $commonObject = new ExtensionCommon;
    $commonObject -> sqlQuery("DROP TABLE `runningprocess`;");
}

/**
 * This function is called on plugin upgrade
 */
function extension_upgrade_runningprocess()
{

}
