#!/usr/bin/perl

use strict;
# use warnings;
use IO::File;
use Cwd;
use File::Copy;

my $BRANCH=$ARGV[0];
my $POP_JOB_ID=$ARGV[1];
my $TEST_MODE=$ARGV[2];
my $TEST_RES=$ARGV[3];
my $WORKSPACE=$ARGV[4];
my $TRIGGER_TYPE=$ARGV[5];
my $GERRIT_PATCHSET_REVISION=$ARGV[6];
my $GERRIT_CHANGE_URL=$ARGV[7];
my $link_head = "http://10.140.90.51:8081/userContent";
my $report_path = "$ENV{'JENKINS_HOME'}/userContent/${BRANCH}/Reports_${POP_JOB_ID}";
my $report_link = "${link_head}/${BRANCH}/Reports_${POP_JOB_ID}";
my $ulphy_link = "http://10.140.90.51:8081/view/GIT_TRUNK";
my $case_list_path = "${WORKSPACE}/tdd_ulphy/C_Test/PHY_UL_Robot_TestENV/ci";

#system("cp $report_path/author $WORKSPACE");

my $ut_path = "UT/BIN";
my $ut_coverage_path = "UT/gcoverHtml";

my $mt_2dsp_fsih_build_path = "MT/Build/FSMR3/2DSP/BIN";
my $mt_1dsp_fsih_build_path = "MT/Build/FSMR3/1DSP/BIN";
my $mt_fzm_build_path = "MT/Build/FZM/BIN";
my $mt_fzm_TASYMDSP_build_path = "MT/Build/FZMASYMDSP/BIN";
my $mt_FSMr4_ULDSP_build_path = "MT/Build/FSMR4/BIN";

my $mt_fsih_test_path = "MT/Test/FSMR3";
my $mt_fzm_test_path = "MT/Test/FZM";
my $mt_fzm_TASYMDSP_test_path = "MT/Test/FZMASYMDSP";
my $mt_fsmr4_uldsp_test_path = "MT/Test/FSMR4";

my $sct_2dsp_build_path = "SCT/Build/2DSP/BIN";
my $sct_3dsp_build_path = "SCT/Build/3DSP/BIN";
my $sct_fzm_build_path = "SCT/Build/FZM/BIN";
my $sct_fzm_TASYMDSP_build_path = "SCT/Build/FZMASYMDSP/BIN";
my $sct_FSMr4_ULDSP_build_path = "SCT/Build/FSMR4/BIN";
my $sct_FSMr4_L1MIMO_build_path = "SCT/Build/FSMR4L1MIMO/BIN";
my $sct_FSMr4_L1MMIMO_build_path = "SCT/Build/FSMR4L1MMIMO/BIN";
my $sct_FSMr4_mMIMO_build_path = "SCT/Build/FSMR4mMIMO/BIN";
my $sct_fzm2cell_build_path = "SCT/Build/FZM2CELL/BIN";
my $slowmode_1dsp_build_path = "SLOWMODE/Build/1DSP/BIN";
my $slowmode_2dsp_build_path = "SLOWMODE/Build/2DSP/BIN";
my $slowmode_fzm_build_path = "SLOWMODE/Build/FZM/BIN";
my $slowmode_FSMr4_ULDSP_build_path = "SLOWMODE/Build/FSMR4/BIN";

my $sct_fzm1pipe_test_path = "SCT/Test/fzm1pipe";
my $sct_fzm2pipe_test_path = "SCT/Test/fzm2pipe";
my $sct_fzm2cell_test_path = "SCT/Test/fzm2cell";
my $sct_fzmonedsp2cell_test_path = "SCT/Test/fzmonedsp2cell";
my $sct_fzmonedsp2cell1pipe_test_path = "SCT/Test/fzmonedsp2cell1pipe";
my $sct_fzm1pipeasym_test_path = "SCT/Test/fzm1pipeasym";
my $sct_fzm2pipeasym_test_path = "SCT/Test/fzm2pipeasym";
my $sct_fzm2cellonedspasym_test_path = "SCT/Test/fzm2cellonedspasym";
my $sct_fsmr4mmimouldsp_test_path = "SCT/Test/fsmr4mmimo";

my $sct_1pipe2dsp_test_path = "SCT/Test/1pipe2dsp";
my $sct_2pipe2dsp_test_path = "SCT/Test/2pipe2dsp";
my $sct_2pipe3dsp_test_path = "SCT/Test/2pipe3dsp";
my $sct_4pipe3dsp_test_path = "SCT/Test/4pipe3dsp";
my $sct_8pipe3dsp_test_path = "SCT/Test/8pipe3dsp";
my $sct_8rx2cell_test_path = "SCT/Test/8Rx2Cell";
my $sct_supercell_test_path = "SCT/Test/supercell";
my $sct_new4Rx2Cell_test_path = "SCT/Test/new4Rx2Cell";
my $sct_new8Rx3Cell_test_path = "SCT/Test/new8Rx3Cell";
my $sct_fsmr4_uldsp_8pipe_test_path = "SCT/Test/8pipefsmr4uldsp";
my $sct_fsmr4_uldsp_2cell8pipe_test_path = "SCT/Test/2cell8pipefsmr4uldsp";
my $sct_fsmr4_uldsp_2cell8pipecomp_test_path = "SCT/Test/2cell8pipefsmr4uldspcomp";
my $sct_fsmr4_uldsp_1pipe_test_path = "SCT/Test/1pipefsmr4uldsp";
my $sct_fsmr4_uldsp_2pipe_test_path = "SCT/Test/2pipefsmr4uldsp";
my $sct_fsmr4_uldsp_4pipe_test_path = "SCT/Test/4pipefsmr4uldsp";
my $sct_fsmr4_uldsp_2cell1pipe_test_path = "SCT/Test/2cell1pipefsmr4uldsp";
my $sct_fsmr4_uldsp_2cell2pipe_test_path = "SCT/Test/2cell2pipefsmr4uldsp";
my $sct_fsmr4_uldsp_2cell4pipe_test_path = "SCT/Test/2cell4pipefsmr4uldsp";
my $sct_fsmr4_uldsp_3cell4pipe_test_path = "SCT/Test/3cell4pipefsmr4uldsp";
my $sct_fsmr4_uldsp_3cell1pool_test_path = "SCT/Test/3cell1poolfsmr4uldsp";
my $sct_fsmr4_2cell4pipeulmimofsmr4_test_path = "SCT/Test/2cell4pipeulmimofsmr4";

my $mailName = "mail_content.html";

open HTML, ">${WORKSPACE}/${mailName}" or die "Could not open ${mailName} for writing.";
print HTML "<!DOCTYPE html PUBLIC\"-\/\/W3C\/\/DTD XHTML 1.0 Transitional\/\/EN\"\"http:\/\/www.w3.org\/TR\/xhtml1\/DTD\/xhtml1-transitional.dtd\">";
print HTML "<html>\n";
&mail_head();
&mail_body();
print HTML "<\/html>\n";
close HTML;

&print_footer($report_link,$ulphy_link);

######################################## SUB FUNCTION ########################################
sub mail_head
{
    print HTML "<html>
    <head>
        <style type=\"text\/css\">
            * {
              font-family:Calibri;
              font-size:100%;
            }
            span.highlight {
                background-color:yellow
            }
            body {
                text-align: left
                font-family:Calibri,Verdana,Sans-serif
                font-size: 100%
                font-style:normal
                font-weight: normal
            }
            table {
                border-collapse: collapse;
                empty-cells: show
                width:100%;
                border-spacing:0;
                white-space: nowrap;
            }
            table td.pass {
                text-align:left;
                background-color:#00FF00
            }
            table td.fail {
                text-align:left;
                background-color:#FF0000
            }
            table th {
                background-color:#D8D8D8;
                color:black;
                white-space: nowrap;
            }
            a {
                text-decoration: underline
                color:#0000C6
            }
            h1 {
              font-size:16px;
            }
            h2 a,h2 {
              font-size:15px;
            }
            h3{
            font-size:14px;
            }
             h4{
              font-size:13px;
            }
             h5 {
            font-size:12px;
            line-height:14px;
            padding:0;
            margin:0;
            }
            <title>ULPHY ${TEST_MODE} Reports for ${BRANCH}: $TEST_RES<\/title>
        <\/style>
    <\/head>";
}

sub mail_body
{
    print HTML "<body>
    <style type=\"text\/css\">
        * {
            font-family:Calibri;
            font-size:100%;
        }
        span.highlight {
            background-color:yellow
        }
        body {
            text-align: left
            font-family:Calibri,Verdana,Sans-serif
            font-size: 100%
            font-style: normal
            font-weight: normal
        }
        table,td{
            border-collapse: collapse;
            empty-cells: show
            width:100%;
            border-spacing:0;
            border:1px solid black;
            text-align:center;
        }
        table td.pass {
            text-align:center;
            background-color:#00FF00
        }
        table td.fail {
            text-align:center;
            background-color:#FF0000
        }
        table td.exp {
            text-align:center;
            background-color:#FF8000
        }
        tr {
            height:30px;
            white-space: nowrap;
        }
        th {
            background-color:#D8D8D8;
            color:black;
            border:1px solid black;
            text-align:center;
        }
        a{
            text-decoration: underline
            color:#B43104;
        }
        h1 {
            font-size:16px;
        }
        h2 {
            font-size:15px;
        }
        h3{
            font-size:14px;
        }
        h4{
            font-size:13px;
        }
        h5 {
            font-size:12px;
            line-height:14px;
            padding:0;
            margin:0;
        }
    <\/style>
    <p><span style=\"font-family: \'Calibri\',\'sans-serif\'\" lang=EN-US>Hello All,<\/span><\/p>
    <p><b>Test result:<span class=\"highlight\">&nbsp;${TEST_RES}<\/span><\/b><\/p>";

    ################################## BASELINE ##########################################
    #my $new_cfg = &read_baseline("$report_path/cfg_tag");
    #if ($TEST_MODE =~ /QT/)
    #{
    #    my $old_cfg = &read_baseline("$report_path/cfg_old");
    #    print HTML "Note: if the test result is passed, the new baseline will be changed to the<font color=blue><i> Changed<\/i><\/font> column, or the baseline will not be changed.<br><br>
    #        <table   id= \"table1\"   border=1   width=90%><tr><th>Name<\/th><th>Original baseline<\/th><th>Changed<\/th><\/tr>";
    #    print_diff_baseline("TRUNK",$old_cfg->{TRUNK},$new_cfg->{TRUNK});
    #    print HTML "<\/table>";
    #}
    #else
    #{
    #    print HTML "<table   id= \"table1\"   border=1   width=90%><tr><th>SS<\/th><th>Current baseline<\/th><\/tr><tr><td><b>TRUNK<\/b><\/td><td>$new_cfg->{TRUNK}<\/td><\/tr><\/table>";
    #}
    #system("echo -n $new_cfg->{TRUNK} > $WORKSPACE/current_version"); # version for email
    ################################## Git Log ##########################################
    if ($TEST_MODE =~/QT/)
    {
        print HTML "<h1>Logs:<\/h1>";
        print HTML "$GERRIT_CHANGE_URL<br>";
        #system("git show --name-status $GERRIT_PATCHSET_REVISION > $report_path/git_log");
        print_git_log_content("$report_path/git_log");
    }
    if ($TRIGGER_TYPE eq "trigger_ut" or $TRIGGER_TYPE eq "trigger_all")
    {
        ################################## UT BUILD ##########################################
        my $warningNum = 0;
        my $result = "pass";
        print HTML "<br><h1>UT Build Part:<\/h1>";
        &print_table_head("Type", "Warning Number", "Result");
        print HTML "<tr><td><a href=\"$report_link\/$ut_path\/build.txt\">UT_ALL<\/a></td>";

        if(-e "$report_path/$ut_path/build_result.txt")
        {
            $warningNum = &print_ut_warning("$report_path/$ut_path/build_result.txt");
        }

        if ($warningNum != 0)
        {
            $result = "fail";
        }

        print HTML "<td class=\"$result\">$warningNum<\/td>";

        if( $result eq "fail" || -e "$report_path/$ut_path/ut_compile_fail")
        {
            print HTML "<td class=\"fail\">fail<\/td>";
        }
        else
        {
            print HTML "<td class=\"pass\">pass<\/td>";
        }
        print HTML "<\/table>";

        ################################## UT TEST ##########################################
        print HTML "<br><h1>UT Test Part:<\/h1>";
        if(-e "$report_path/$ut_path/build_result.txt")
        {
            &print_ut_content("$report_path/$ut_path/build_result.txt");
        }
        # if(-e "/home/tdd_lte_ulphy_ci/.jenkins/jobs/${BRANCH}_UT_BUILD_CLANG/workspace/clang.txt")
        # {
            # copy("/home/tdd_lte_ulphy_ci/.jenkins/jobs/${BRANCH}_UT_BUILD_CLANG/workspace/clang.txt", "$report_path/$ut_path/clang.txt");
            # print HTML "<br><h1>UT Clang Part:<\/h1>";
            # &print_clang_content("$report_path/$ut_path/clang.txt");
        # }
    }

    if ($TRIGGER_TYPE eq "trigger_mt" or $TRIGGER_TYPE eq "trigger_all" or $TRIGGER_TYPE eq "trigger_mt_sct")
    {
        ################################## MT BUILD ##########################################
        print HTML "<br><h1>MT Build Part:<\/h1>";
        &print_table_head("Target", "Bin", "Warning");
        if(-e "$report_path/$mt_2dsp_fsih_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$mt_2dsp_fsih_build_path/build_result.txt");
            &print_build($hash,"$report_link/$mt_2dsp_fsih_build_path","FSMr3-UL8DSP-DL8DSP");
        }
        else
        {
            print HTML "<tr><td>FSMr3-UL8DSP-DL8DSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$mt_1dsp_fsih_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$mt_1dsp_fsih_build_path/build_result.txt");
            &print_build($hash,"$report_link/$mt_1dsp_fsih_build_path","FSMr3-L1DSP");
        }
        else
        {
            print HTML "<tr><td>FSMr3-L1DSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$mt_fzm_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$mt_fzm_build_path/build_result.txt");
            &print_build($hash,"$report_link/$mt_fzm_build_path","FZM-L1L2DSP");
        }
        else
        {
            print HTML "<tr><td>FZM-L1L2DSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$mt_fzm_TASYMDSP_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$mt_fzm_TASYMDSP_build_path/build_result.txt");
            &print_build($hash,"$report_link/$mt_fzm_TASYMDSP_build_path","FZM-TASYMDSP");
        }
        else
        {
            print HTML "<tr><td>FZM-TASYMDSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$mt_FSMr4_ULDSP_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$mt_FSMr4_ULDSP_build_path/build_result.txt");
            &print_build($hash,"$report_link/$mt_FSMr4_ULDSP_build_path","FSMr4-ULDSP");
        }
        else
        {
            print HTML "<tr><td>FSMr4-ULDSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        print HTML "<\/table>";

        ############################## MT  TEST ####################################
        print HTML "<br><h1>MT Test Part:<\/h1>";
        if ($TEST_MODE =~/QT/)
        {
            &print_table_head("Target", "Pass", "Fail", "Not Run", "Pass Rate");
            &get_mt_qt_test_results();
        }
        else
        {
            &print_mt_ft_head();
            &get_mt_ft_test_results();
        }
        print HTML "<\/table>";
    }

    if ($TRIGGER_TYPE eq "trigger_sct" or $TRIGGER_TYPE eq "trigger_all" or $TRIGGER_TYPE eq "trigger_mt_sct")
    {
        ###################################### SCT BUILD #########################################
        print HTML "<br><h1>SCT Build Part:<\/h1>";
        &print_table_head("Target", "Bin", "Warning");
        if(-e "$report_path/$sct_2dsp_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$sct_2dsp_build_path/build_result.txt");
            &print_build($hash,"$report_link/$sct_2dsp_build_path","FSMr3-L1DSP");
        }
        else
        {
            print HTML "<tr><td>FSMr3-L1DSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$sct_3dsp_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$sct_3dsp_build_path/build_result.txt");
            &print_build($hash,"$report_link/$sct_3dsp_build_path","FSMr3-UL8DSP-DL8DSP");
        }
        else
        {
            print HTML "<tr><td>FSMr3-UL8DSP-DL8DSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$sct_fzm_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$sct_fzm_build_path/build_result.txt");
            &print_build($hash,"$report_link/$sct_fzm_build_path","FZM-L1L2DSP");
        }
        else
        {
            print HTML "<tr><td>FZM-L1L2DSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$sct_fzm_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$sct_fzm_build_path/build_result.txt");
            &print_build($hash,"$report_link/$sct_fzm_build_path","FZM-L1EXL2DSP");
        }
        else
        {
            print HTML "<tr><td>FZM-L1EXL2DSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$sct_fzm_TASYMDSP_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$sct_fzm_TASYMDSP_build_path/build_result.txt");
            &print_build($hash,"$report_link/$sct_fzm_TASYMDSP_build_path","FZM-TASYMDSP");
        }
        else
        {
            print HTML "<tr><td>FZM-TASYMDSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$sct_fzm2cell_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$sct_fzm2cell_build_path/build_result.txt");
            &print_build($hash,"$report_link/$sct_fzm2cell_build_path","FZM-L1L1DSP");
        }
        else
        {
            print HTML "<tr><td>FZM-L1L1DSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$sct_FSMr4_ULDSP_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$sct_FSMr4_ULDSP_build_path/build_result.txt");
            &print_build($hash,"$report_link/$sct_FSMr4_ULDSP_build_path","FSMr4-ULDSP-DLDSP");
        }
        else
        {
            print HTML "<tr><td>FSMr4-ULDSP-DLDSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }

        if(-e "$report_path/$sct_FSMr4_L1MIMO_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$sct_FSMr4_L1MIMO_build_path/build_result.txt");
            &print_build($hash,"$report_link/$sct_FSMr4_L1MIMO_build_path","FSMr4-ULDSP-DLDSP-L1Call");
        }
        else
        {
            print HTML "<tr><td>FSMr4-ULDSP-DLDSP-L1Call<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }

        if(-e "$report_path/$sct_FSMr4_L1MMIMO_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$sct_FSMr4_L1MMIMO_build_path/build_result.txt");
            &print_build($hash,"$report_link/$sct_FSMr4_L1MMIMO_build_path","FSMr4-ULDSP-DLULDSP-L1Call");
        }
        else
        {
            print HTML "<tr><td>FSMr4-ULDSP-DLULDSP-L1Call<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }

        if(-e "$report_path/$sct_FSMr4_mMIMO_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$sct_FSMr4_mMIMO_build_path/build_result.txt");
            &print_build($hash,"$report_link/$sct_FSMr4_mMIMO_build_path","FSMr4-ULDSP-DLULDSP");
        }
        else
        {
            print HTML "<tr><td>FSMr4-ULDSP-DLULDSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$slowmode_1dsp_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$slowmode_1dsp_build_path/build_result.txt");
            &print_build($hash,"$report_link/$slowmode_1dsp_build_path","SLOWMODE-FSMr3-L1DSP");
        }
        else
        {
            print HTML "<tr><td>SLOWMODE-FSMr3-L1DSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$slowmode_2dsp_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$slowmode_2dsp_build_path/build_result.txt");
            &print_build($hash,"$report_link/$slowmode_2dsp_build_path","SLOWMODE-FSMr3-UL8DSP-DL8DSP");
        }
        else
        {
            print HTML "<tr><td>SLOWMODE-FSMr3-UL8DSP-DL8DSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$slowmode_fzm_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$slowmode_fzm_build_path/build_result.txt");
            &print_build($hash,"$report_link/$slowmode_fzm_build_path","SLOWMODE-FZM-L1L2DSP");
        }
        else
        {
            print HTML "<tr><td>SLOWMODE-FZM-L1L2DSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        if(-e "$report_path/$slowmode_FSMr4_ULDSP_build_path/build_result.txt")
        {
            my $hash = &read_build("$report_path/$slowmode_FSMr4_ULDSP_build_path/build_result.txt");
            &print_build($hash,"$report_link/$slowmode_FSMr4_ULDSP_build_path","SLOWMODE-FSMr4-ULDSP-DLDSP");
        }
        else
        {
            print HTML "<tr><td>SLOWMODE-FSMr4-ULDSP-DLDSP<\/td><td class=\"exp\">N\\A<\/td><td class=\"exp\">N\\A<\/td><\/tr>\n";
        }
        print HTML "<\/table>";

        ############################### SCT TEST ####################################
        print HTML "<br><h1>SCT Test Part:<\/h1>";
        if ($TEST_MODE =~/QT/)
        {
            &print_table_head("Target", "Deployment", "Configuration", "Pass", "Fail", "Not Run", "Pass Rate");
            &get_sct_qt_test_results();
        }
        else
        {
            &print_sct_ft_head();
            &get_sct_ft_test_results();
        }
        print HTML "<\/table>";
    }

    ################################# StaticAnalysis ##############################
    if (-e "$report_path/StaticAnalysis/Klocwork/summary_klocwork.txt")
    {
        &print_Klocwork_content("$report_path/StaticAnalysis/Klocwork/summary_klocwork.txt");
    }

    if (-e "$report_path/StaticAnalysis/Complexity/summary_cmt.txt")
    {
        print HTML "<\/table><h1>Complexity Analysis Part:<\/h1>
            <table style=\"table-layout:fixed;width:5000\">
            <tr>
            <th width=\"120\">Old CCN<\/th>
            <th width=\"120\">New CCN<\/th>
            <th width=\"500\">Function<\/th>
            <th width=\"1000\">File<\/th>
            <\/tr>";
        &print_static_analysis_content("$report_path/StaticAnalysis/Complexity/summary_cmt.txt");
    }
    if (-e "$report_path/StaticAnalysis/Duplicity/summary_cpd.txt")
    {
        print HTML "<\/table><h1>Duplicity Analysis Part:<\/h1><table>
            <tr>
            <th>Old Duplicity<\/th>
            <th>New Duplicity<\/th>
            <th>File<\/th>
            <\/tr>";
        &print_static_analysis_content("$report_path/StaticAnalysis/Duplicity/summary_cpd.txt");
    }
    print HTML "<\/table>";
}

sub read_baseline
{
    my $config = shift;

    open TXT, "<$config" or die "Could not open file $config";

    my @lines = <TXT>;
    close TXT;

    my %cfg;

    foreach(@lines)
    {
        if (/(\w*)(\s*)R(\d*)/)
        {
            $cfg{$1} = $3;
            print "key:$1, value:$cfg{$1}\n";
        }
    }

    return \%cfg;
}

sub print_diff_baseline
{
    my ($ss, $old, $new) =@_;

    if ($old != $new)
    {
        print HTML "<tr><td><b>$ss<\/b><\/td><td>$old<\/td><td><font color=red>$new<\/font><\/td><\/tr>\n";
    }
    else
    {
        print HTML "<tr><td><b>$ss<\/b><\/td><td>$old<\/td><td>$new<\/td><\/tr>\n";
    }
}

sub read_build
{
    my $file = $_[0];
    open TXT, "<$file" or die "Could not open file $file";
    my %ny_dsp_info;
    $ny_dsp_info{war} = 0;

    foreach(<TXT>)
    {
        if(/.*all passed! but add (\d+) link warning!/)
        {
            $ny_dsp_info{war} = $1;
        }

        elsif(/all passed!/)
    {
            $ny_dsp_info{bin} = "pass";
        }
        else
        {
            $ny_dsp_info{bin} = "fail";
        }
    }

    close TXT;
    return \%ny_dsp_info;
}

sub print_build
{
    my ($dsp_hash,$link_path,$name) = @_;
    print HTML "<tr><td><a href=\"$link_path\">$name<\/a><\/td>";
    if($dsp_hash->{bin} =~ /pass/i)
    {
        print HTML "<td class=\"pass\">pass<\/td>";
    }
    elsif($dsp_hash->{bin} =~ /fail/i)
    {
        print HTML "<td class=\"fail\">fail<\/td>";
    }

    if($dsp_hash->{war} > 0)
    {
        print HTML "<td class=\"fail\">add ".$dsp_hash->{war}." warning<\/td>";
    }
    else
    {
        print HTML "<td class=\"pass\">pass<\/td>";
    }
    print HTML "<\/tr>\n";
}

sub print_clang_content
{
    my $file=shift;
    my $error=0;
    my $warning=0;
    my $result="pass";
    open(RES,$file);
    my @content = <RES>;
    &print_table_head("Type", "Error Number", "Warning Number", "Result");
    for(my $i=@content-1;$i>=0;$i--)
    {
        my $line = $content[$i];
        if ($line =~ /error:(.*);warning:(.*)/)
        {
            $error = $1;
            $warning = $2;
            if ($error != "0" || $warning != "0")
            {
                $result = "fail"
            }
            print HTML "<tr><td><a href=\"$report_link\/$ut_path\/clang.txt\">UT_CLANG<\/a></td>";
            print HTML "<td>$error</td><td>$warning</td><td class=\"$result\">$result<\/td><\/tr>";
        }
    }
    print HTML "<\/table>";
}

sub print_ut_warning
{
    my $result_file=shift;
    my $warningNum = 0;
    open(RES,$result_file);
    my @content = <RES>;
    for(my $i=0;$i<@content;$i++)
    {
        my $line = $content[$i];
        if ($line =~ /Warning number is (.*)/)
        {
            $warningNum = $1;
            last;
        }
    }
    close RES;

    return $warningNum;
}

sub print_ut_content
{
    my $result_file=shift;
    my $passrate;
    my $funcCoverageflag = 0;

    open(RES,$result_file);
    my @content = <RES>;
    &print_table_head("TestSuit", "Pass", "Fail", "PassRate", "Valgrind Issue Number");
    for(my $i=0;$i<@content;$i++)
    {
        my $line = $content[$i];
        if ($line =~ /UlPhy(.*):\[Result\]:failNum:(.*);passNum:(.*);memError:(.*);total:/)
        {
            my $fail = $2;
            my $pass = $3;
            my $valgrind = $4;
            my $testsuit =$1;
            print HTML "<tr><td><a href=\"$report_link\/$ut_path\/summary_UlPhy${testsuit}.txt\">$testsuit<\/a></td>";
            if ($pass != "" && $fail == "")
            {
              $passrate = 100;
              print HTML "<td>$pass<\/td>";
              print HTML "<td>0<\/td>";
            }
            if ($pass != "" && $fail != "")
            {
                $passrate = ($pass/($pass+$fail))*100;
                print HTML "<td>$pass<\/td>";
                print HTML "<td>$fail<\/td>";
            }
            if ($pass == "" && $fail != "")
            {
                $passrate = 0;
                print HTML "<td>0<\/td>";
                print HTML "<td>$fail<\/td>";
            }
            if ($pass == "" && $fail =="")
            {
                $passrate = "N/A";
                print HTML "<td bgcolor=\"#FF8000\">N/A<\/td>";
                print HTML "<td bgcolor=\"#FF8000\">N/A<\/td>";
            }

            if ($passrate == 100)
            {
                print HTML "<td class=\"pass\">$passrate"."\%<\/td>";
            }
            else
            {
                print HTML "<td class=\"fail\">$passrate"."\%<\/td>";
            }

            $valgrind =~ s/^\s+//;
            $valgrind =~ s/\s+$//;
            if ($valgrind == 0)
            {
               print HTML "<td>$valgrind<\/td><\/tr>";
            }
            else
            {
               print HTML "<td class=\"fail\">$valgrind<\/td>";
            }
        }

        if ($line =~ /Result:(.*);newLineRate:(.*);newPopId:(.*);baseLineRate:(.*);basePopId:(.*)/)
        {
            print HTML "<\/table>";
            my $result = 'pass';
            my $newLineRate = 'N/A';
            my $baseLineRate = 'N/A';
            my $newPopId = 'N/A';
            my $basePopId = 'N/A';

            if ($2 ne 'None') { $newLineRate =  sprintf("%.6f%%", $2);}
            if ($3 ne 'None') { $newPopId =  $3;}
            if ($4 ne 'None') { $baseLineRate = sprintf("%.6f%%", $4); }
            if ($5 ne 'None') { $basePopId =  $5;}
            $result = lc($1);

            # if (($4 ne "None") and ($4 == $2)){
            #     next;
            # }

            my $new_link = "${link_head}/${BRANCH}/Reports_${newPopId}";
            my $base_link = "${link_head}/${BRANCH}/Reports_${basePopId}";

            print HTML "<h1>UT Coverage Part:<\/h1>";
            &print_table_head("Base Coverage", "New Coverage");

            if ($4 eq "None"){
                print HTML "<tr><td>$baseLineRate</td>";
                print HTML "<td><a href=\"$new_link\/$ut_coverage_path\/cobertura.html\">$newLineRate<\/a></td><\/tr>";
            }else{
                print HTML "<tr><td><a href=\"$base_link\/$ut_coverage_path\/cobertura.html\">$baseLineRate<\/a></td>";
                print HTML "<td class=\"${result}\"><a href=\"$new_link\/$ut_coverage_path\/cobertura.html\">$newLineRate<\/a></td><\/tr>";
            }
        }

        if ($line =~ /coverageFile:(.*);coverageFunc:(.*);coverageRate:(.*)/)
        {
            my $file = $1;
            my $func = $2;
            my $coverage = $3;

            if ($funcCoverageflag == 0)
            {
                print HTML "<\/table>";

                print HTML "<h1>New or changed methods/functions in which line coverage is less than 80%:<\/h1><table>
                    <tr><th width=\"100\">File<\/th><th width=\"150\">Function<\/th><th width=\"150\">Line Coverage<\/th></tr>";
                $funcCoverageflag = 1;
            }

            print HTML "<tr><td>$file<\/td><td>$func<\/td><td>$coverage<\/td><\/tr>";
        }
    }
    print HTML "<\/table>";
    close RES;
}

sub print_table_head
{
    print HTML "<table border=\"1\"><tr>";
    foreach my $table_item (@_)
    {
        print HTML "<th width=\"200\">$table_item<\/th>";
    }
    print HTML "<\/tr>";
}

sub get_mt_qt_test_results
{
    #MT_ALL
    my ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$mt_fsih_test_path", "test_result.txt", &get_case_number("mt_qtlist_Job[12]"));
    &print_mt_qt_content("FSMr3-UL8DSP-DL8DSP-L1DSP","$report_link/$mt_fsih_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";

    #FZM
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$mt_fzm_test_path", "test_result.txt", &get_case_number("mt_qtlist_fzm"));
    &print_mt_qt_content("FZM-L1L2DSP","$report_link/$mt_fzm_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";

    #FZMASYMDSP
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$mt_fzm_TASYMDSP_test_path", "test_result.txt", &get_case_number("mt_qtlist_fzmasym"));
    &print_mt_qt_content("FZM-TASYMDSP","$report_link/$mt_fzm_TASYMDSP_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";

    #FSMR4
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$mt_fsmr4_uldsp_test_path", "test_result.txt", &get_case_number("mt_qtlist_fsmr4uldsp"));
    &print_mt_qt_content("FSMr4-ULDSP","$report_link/$mt_fsmr4_uldsp_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
}

sub get_mt_ft_test_results
{
    #MT_ALL MT/Test/Reports
    my ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$mt_fsih_test_path", "regression_test_result.txt", 0);
    my ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$mt_fsih_test_path", "newfeature_test_result.txt", 0);
    &print_mt_ft_content("FSMr3-UL8DSP-DL8DSP-L1DSP","$report_link/$mt_fsih_test_path/regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"$report_link/$mt_fsih_test_path/newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr><tr>";

    #FZM
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$mt_fzm_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$mt_fzm_test_path", "newfeature_test_result.txt", 0);
    &print_mt_ft_content("FZM-L1L2DSP","$report_link/$mt_fzm_test_path/regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"$report_link/$mt_fzm_test_path/newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr><tr>";

    #FZMASYM
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$mt_fzm_TASYMDSP_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$mt_fzm_TASYMDSP_test_path", "newfeature_test_result.txt", 0);
    &print_mt_ft_content("FZM-TASYMDSP","$report_link/$mt_fzm_TASYMDSP_test_path/regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"$report_link/$mt_fzm_TASYMDSP_test_path/newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr><tr>";

    #FSMR4_ULDSP
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$mt_fsmr4_uldsp_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$mt_fsmr4_uldsp_test_path", "newfeature_test_result.txt", 0);
    &print_mt_ft_content("FSMr4-ULDSP","$report_link/$mt_fsmr4_uldsp_test_path/regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"$report_link/$mt_fsmr4_uldsp_test_path/newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
}

sub get_test_results
{
    my ($report_folder, $result_file, $total_case) = @_;
    my ($res_pass,$res_fail,$res_not_run,$res_unstable,$res_pass_rate);
    my @all_files = `find $report_folder -name $result_file`;
    my $failinfo=&get_test_fial_info($report_folder);
    if ((@all_files == 1) and ($all_files[0] !~ /No such file or directory/))
    {
        ($res_pass,$res_fail,$res_not_run) = &read_test_res($all_files[0]);
    }
    elsif (@all_files > 1)
    {
        foreach my $rfile (@all_files)
        {
            next if($rfile =~ /\/INIT\//);
            my ($temp_pass,$temp_fail,$temp_not_run) = &read_test_res($rfile);
            $res_pass += $temp_pass;
            $res_fail += $temp_fail;
            $res_not_run += $temp_not_run;
        }
    }

    if (($res_pass+$res_fail+$res_not_run) == 0)
    {
        $res_pass_rate = 0;
        $res_not_run = $total_case
    }
    elsif (($res_pass+$res_fail+$res_not_run) < $total_case)
    {
        $res_pass_rate = ($res_pass/$total_case)*100;
        $res_not_run = ($total_case - $res_pass - $res_fail)
    }
    else
    {
        $res_pass_rate = ($res_pass/($res_pass+$res_fail+$res_not_run))*100;
    }
    return ($res_pass,$res_fail,$res_not_run,$res_pass_rate,$failinfo)
}

sub read_test_res
{
    my $file = shift;
    open TXT, "<$file" or die "Could not open file $file";

    my @lines = <TXT>;
    close TXT;

    my ($pass,$fail,$not_run,$pass_rate);

    foreach(@lines)
    {
        if($_ =~ /Total:(\d+);Pass:(\d+);Unstable:(\d+);Fail:(\d+);NoRun:(\d+)/)
        {
            $pass = $2;
            if ($3 != 0)
            {
                system("echo -n ' Restrict' > ${WORKSPACE}/restrict");
            }
            $fail = $4+$3;
            $not_run = $5;
            if($1 eq 0)
            {
                $pass_rate = 0;
            } else {
                $pass_rate = ($2/$1)*100;
            }
            last;
        }
    }
    return ($pass,$fail,$not_run,$pass_rate);
}

sub print_mt_qt_content
{
    my ($dspType,$jenkinsLink,$qtpass,$qtfail,$qtnot_run,$qtpass_rate) = @_;
    my $color = "";
    ($qtpass,$qtfail,$qtnot_run,$qtpass_rate) = &sctandmt_abnormal($qtpass,$qtfail,$qtnot_run,$qtpass_rate);

    if ($qtpass_rate eq 100)
    {
        $color = "#00FF00";
        $qtpass_rate = $qtpass_rate."\%";
    }
    elsif ($qtpass_rate eq "N/A") {
        $color = "#FF8000";
    }
    else
    {
        $color = "#FF0000";
        $qtpass_rate = $qtpass_rate."\%";
    }

    print HTML "<td><a href=$jenkinsLink>$dspType<\/a><\/td>";
    if ($qtpass_rate eq "N/A")
    {
        print HTML "<td bgcolor=\"$color\">$qtpass<\/td><td bgcolor=\"$color\">$qtfail<\/td><td bgcolor=\"$color\">$qtnot_run<\/td>";
    } else {
        print HTML "<td>$qtpass<\/td><td>$qtfail<\/td><td>$qtnot_run<\/td>";
    }
    print HTML "<td bgcolor=\"$color\">$qtpass_rate<\/td>";
}

sub sctandmt_abnormal {
    # body...
    my ($abregPass,$abregFail,$abregNotrun,$abregPassrate,$abnewPass,$abnewFail,$abnewNoutrun) = @_;
    if ($abregPass eq "") {
        $abregPass = "N/A";
    }
    if ($abregFail eq "") {
        $abregFail = "N/A";
    }
    if ($abregNotrun eq "") {
        $abregNotrun = "N/A";
    }
    if ($abregPassrate eq "") {
        $abregPassrate = "N/A";
    }
    if ($abnewPass eq "") {
        $abnewPass = "N/A";
    }
    if ($abnewFail eq "") {
        $abnewFail = "N/A";
    }
    if ($abnewNoutrun eq "") {
        $abnewNoutrun = "N/A";
    }
    return ($abregPass,$abregFail,$abregNotrun,$abregPassrate,$abnewPass,$abnewFail,$abnewNoutrun);
}

sub print_mt_ft_head
{
    print HTML "<table border=\"1\">
    <tr>
    <th rowspan=\"2\">Target<\/th>
    <th width=\"100\" colspan=\"5\" >Regression<\/th>
    <th width=\"100\" colspan=\"4\">New Feature<\/th>
    <\/tr>
    <tr>
    <th width=\"100\">Report<\/th>
    <th width=\"100\">Pass<\/th>
    <th width=\"100\">Fail<\/th>
    <th width=\"100\">Not Run<\/th>
    <th width=\"100\">Pass Rate<\/th>
    <th width=\"100\">Report<\/th>
    <th width=\"100\">Pass<\/th>
    <th width=\"100\">Fail<\/th>
    <th width=\"100\">Not Run<\/th>
    <\/tr>
    ";
}

sub print_sct_ft_head
{
    print HTML "<table border=\"1\">
    <tr>
    <th rowspan=\"2\">Target<\/th>
    <th rowspan=\"2\">Deployment<\/th>
    <th width=\"100\" rowspan=\"2\">Configuration<\/th>
    <th width=\"100\" colspan=\"5\" >Regression<\/th>
    <th width=\"100\" colspan=\"4\">New Feature<\/th>
    <\/tr>
    <tr>
    <th width=\"100\">Report<\/th>
    <th width=\"100\">Pass<\/th>
    <th width=\"100\">Fail<\/th>
    <th width=\"100\">Not Run<\/th>
    <th width=\"100\">Pass Rate<\/th>
    <th width=\"100\">Report<\/th>
    <th width=\"100\">Pass<\/th>
    <th width=\"100\">Fail<\/th>
    <th width=\"100\">Not Run<\/th>
    <\/tr>
    ";
}

sub print_mt_ft_content
{
    my ($dspType,$regLink,$regPass,$regFail,$regNotrun,$regPassrate,$newLink,$newPass,$newFail,$newNoutrun,$newPassrate) = @_;
    ($regPass,$regFail,$regNotrun,$regPassrate,$newPass,$newFail,$newNoutrun) = &sctandmt_abnormal($regPass,$regFail,$regNotrun,$regPassrate,$newPass,$newFail,$newNoutrun);

    my $color = "";
    my $nfcolor = "";
    if ($regPassrate eq 100)
    {
        $color = "#00FF00";
        $regPassrate = $regPassrate."\%";
    }
    elsif ($regPassrate eq "N/A") {
        $color = "#FF8000";
    }
    else
    {
        $color = "#FF0000";
        $regPassrate = $regPassrate."\%";
    }

    if ($newPassrate eq 100)
    {
        $nfcolor = "#00FF00";
    }
    elsif ($newPassrate eq "") {
        $nfcolor = "#FF8000";
    }
    else
    {
        $nfcolor = "#00FF00";
    }

    print HTML " <td >$dspType<\/td><td bgcolor=\"#D8D8D8\"><a href=\"$regLink\">LINK<\/a><\/td>";
    if ($regPassrate eq "N/A") {
        print HTML "<td bgcolor=\"$color\">$regPass<\/td><td bgcolor=\"$color\">$regFail<\/td><td bgcolor=\"$color\">$regNotrun<\/td>";

    } else {
        print HTML "<td>$regPass<\/td><td>$regFail<\/td><td>$regNotrun<\/td>";
    }

    print HTML "<td bgcolor=\"$color\">$regPassrate<\/td><td bgcolor=\"#D8D8D8\"><a href=\"$newLink\">LINK<\/a><\/td>";
    if ($newPassrate eq "") {
        print HTML "<td bgcolor=\"$nfcolor\">$newPass<\/td><td bgcolor=\"$nfcolor\">$newFail<\/td><td bgcolor=\"$nfcolor\">$newNoutrun<\/td>";
    } else {
        print HTML "<td>$newPass<\/td><td>$newFail<\/td><td>$newNoutrun<\/td>";
    }
}

sub get_sct_qt_test_results
{
    #2DSP
    print HTML "<tr><td rowspan=\"1\">FSMr3-L1DSP<\/td><td rowspan=\"1\">2DSP<\/td>";
    #2PIPE2DSP
    my ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_2pipe2dsp_test_path", "test_result.txt", &get_case_number("sct_qtlist_2pipe2dsp"));
    &print_sct_qt_content("1CELL 2PIPE","$report_link/$sct_2pipe2dsp_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    
    #3DSP
    print HTML "<tr><td rowspan=\"5\">FSMr3-UL8DSP-DL8DSP<\/td>";
    print HTML "<td rowspan=\"2\">3DSP<\/td>";
    #4PIPE3DSP
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_4pipe3dsp_test_path", "test_result.txt", &get_case_number("sct_qtlist_4pipe3dsp"));
    &print_sct_qt_content("1CELL 4PIPE","$report_link/$sct_4pipe3dsp_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #8PIPE3DSP
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_8pipe3dsp_test_path", "test_result.txt", &get_case_number("sct_qtlist_8pipe3dsp"));
    &print_sct_qt_content("1CELL 8PIPE","$report_link/$sct_8pipe3dsp_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    print HTML "<td rowspan=\"1\">5DSP<\/td>";
    #supercell
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_supercell_test_path", "test_result.txt", &get_case_number("sct_qtlist_supercell"));
    &print_sct_qt_content("1CELL SUPERCELL","$report_link/$sct_supercell_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    print HTML "<td rowspan=\"1\">6DSP<\/td>";
    #new4Rx2Cell
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_new4Rx2Cell_test_path", "test_result.txt", &get_case_number("sct_qtlist_new4Rx2Cell"));
    &print_sct_qt_content("2CELL 4PIPE","$report_link/$sct_new4Rx2Cell_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    print HTML "<td rowspan=\"1\">9DSP<\/td>";
    #new8Rx3Cell
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_new8Rx3Cell_test_path", "test_result.txt", &get_case_number("sct_qtlist_new8Rx3Cell"));
    &print_sct_qt_content("3CELL 8PIPE","$report_link/$sct_new8Rx3Cell_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    
    #FZM
    #fzm2pipe
    print HTML "<tr><td rowspan=\"1\">FZM-L1L2DSP<\/td><td rowspan=\"1\">Single Cell Basic<\/td>";
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fzm2pipe_test_path", "test_result.txt", &get_case_number("sct_qtlist_fzm2pipe"));
    &print_sct_qt_content("1CELL 2PIPE","$report_link/$sct_fzm2pipe_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #fzm2cell
    print HTML "<tr><td rowspan=\"1\">FZM-L1L1DSP<\/td><td rowspan=\"1\">SFN Basic<\/td>";
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fzm2cell_test_path", "test_result.txt", &get_case_number("sct_qtlist_fzm2cell"));
    &print_sct_qt_content("2CELL 2PIPE","$report_link/$sct_fzm2cell_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #onedsp2cell
    print HTML "<tr><td rowspan=\"1\">FZM-L1EXL2DSP<\/td><td rowspan=\"1\">Two Cell Basic<\/td>";
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fzmonedsp2cell_test_path", "test_result.txt", &get_case_number("sct_qtlist_fzmonedsp2cell"));
    &print_sct_qt_content("2CELL 2PIPE","$report_link/$sct_fzmonedsp2cell_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    
    #FZMASYM
    print HTML "<tr><td rowspan=\"2\">FZM-TASYMDSP<\/td><td rowspan=\"2\">Two Cell SDL<\/td>";
    #fzm2pipeasym
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fzm2pipeasym_test_path", "test_result.txt", &get_case_number("sct_qtlist_fzm2pipeasym"));
    &print_sct_qt_content("1CELL 2PIPE","$report_link/$sct_fzm2pipeasym_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #fzm2cellonedspasym
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fzm2cellonedspasym_test_path", "test_result.txt", &get_case_number("sct_qtlist_fzm2cellonedspasym"));
    &print_sct_qt_content("2CELL 2PIPE","$report_link/$sct_fzm2cellonedspasym_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    
    #FSMR4
    print HTML "<tr><td rowspan=\"10\">FSMr4-ULDSP-DLDSP<\/td>";
    print HTML "<td rowspan=\"9\">One Pool<\/td>";
    #1pipefsmr4uldsp
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fsmr4_uldsp_1pipe_test_path", "test_result.txt", &get_case_number("sct_qtlist_1pipefsmr4uldsp"));
    &print_sct_qt_content("1CELL 1PIPE","$report_link/$sct_fsmr4_uldsp_1pipe_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #2pipefsmr4uldsp
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2pipe_test_path", "test_result.txt", &get_case_number("sct_qtlist_2pipefsmr4uldsp"));
    &print_sct_qt_content("1CELL 2PIPE","$report_link/$sct_fsmr4_uldsp_2pipe_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #4pipefsmr4uldsp
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fsmr4_uldsp_4pipe_test_path", "test_result.txt", &get_case_number("sct_qtlist_4pipefsmr4uldsp"));
    &print_sct_qt_content("1CELL 4PIPE","$report_link/$sct_fsmr4_uldsp_4pipe_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #8pipefsmr4uldsp
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fsmr4_uldsp_8pipe_test_path", "test_result.txt", &get_case_number("sct_qtlist_8pipefsmr4uldsp"));
    &print_sct_qt_content("1CELL 8PIPE","$report_link/$sct_fsmr4_uldsp_8pipe_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #2cell1pipefsmr4uldsp
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell1pipe_test_path", "test_result.txt", &get_case_number("sct_qtlist_2cell1pipefsmr4uldsp"));
    &print_sct_qt_content("2CELL 1PIPE","$report_link/$sct_fsmr4_uldsp_2cell1pipe_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #2cell2pipefsmr4uldsp
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell2pipe_test_path", "test_result.txt", &get_case_number("sct_qtlist_2cell2pipefsmr4uldsp"));
    &print_sct_qt_content("2CELL 2PIPE","$report_link/$sct_fsmr4_uldsp_2cell2pipe_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #2cell4pipefsmr4uldsp
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell4pipe_test_path", "test_result.txt", &get_case_number("sct_qtlist_2cell4pipefsmr4uldsp"));
    &print_sct_qt_content("2CELL 4PIPE","$report_link/$sct_fsmr4_uldsp_2cell4pipe_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #2cell8pipefsmr4uldsp
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell8pipe_test_path", "test_result.txt", &get_case_number("sct_qtlist_2cell8pipefsmr4uldsp_Job[123]"));
    &print_sct_qt_content("2CELL 8PIPE","$report_link/$sct_fsmr4_uldsp_2cell8pipe_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #3cell1poolfsmr4uldsp
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fsmr4_uldsp_3cell1pool_test_path", "test_result.txt", &get_case_number("sct_qtlist_3cell1poolfsmr4uldsp"));
    &print_sct_qt_content("3CELL","$report_link/$sct_fsmr4_uldsp_3cell1pool_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    print HTML "<td rowspan=\"1\">Two Pool<\/td>";
    #3cell4pipefsmr4uldsp
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fsmr4_uldsp_3cell4pipe_test_path", "test_result.txt", &get_case_number("sct_qtlist_3cell4pipefsmr4uldsp"));
    &print_sct_qt_content("3CELL 4PIPE","$report_link/$sct_fsmr4_uldsp_3cell4pipe_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
    #FSMr4mMIMO
    print HTML "<tr><td rowspan=\"1\">FSMr4-ULDSP-DLULDSP<\/td><td rowspan=\"1\">mMIMO<\/td>";
    ($qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo) = &get_test_results("$report_path/$sct_fsmr4mmimouldsp_test_path", "test_result.txt", &get_case_number("sct_qtlist_fsmr4mmimo"));
    &print_sct_qt_content("1CELL 64PIPE","$report_link/$sct_fsmr4mmimouldsp_test_path/Summary.html",$qt_pass,$qt_fail,$qt_not_run,$qt_pass_rate,$failinfo);
    print HTML "<\/tr>";
}

sub get_test_fial_info {
    my $failtypelist="";
    my ($report_folder)=@_;
    my @all_summary_files=`find $report_folder -name "summary.txt"`;

    foreach my $rfile (@all_summary_files)
    {
        my @fail=`grep "FAIL" $rfile`;
        foreach my $failtype (@fail)
        {
            my @newlist=split(/,/,$failtype);

            if (@newlist[1] =~ "FAIL:Setup failed: Please check if bts reboot by powerbreak for: Radio Time configuration failed with status = 1") {
               $failtypelist = $failtypelist."PB ERR."
            }
        }

    }
    return $failtypelist
}
sub print_sct_qt_content
{
    my ($anteType,$jenkinsLink,$qtpass,$qtfail,$qtnot_run,$qtpass_rate,$failinfo) = @_;
    my $color = "";
    ($qtpass,$qtfail,$qtnot_run,$qtpass_rate) = &sctandmt_abnormal($qtpass,$qtfail,$qtnot_run,$qtpass_rate);
    if ($qtpass_rate eq 100)
    {
        $color = "#00FF00";
        $qtpass_rate = $qtpass_rate."\%";
    }
    elsif ($qtpass_rate eq "N/A") {
        $color = "#FF8000";
    }
    else
    {
        $color = "#FF0000";
        $qtpass_rate = $qtpass_rate."\%";
    }

    print HTML "<td bgcolor=\"#D8D8D8\"><a href=$jenkinsLink>$anteType<\/a><\/td>";
    if ($qtpass_rate eq "N/A")
    {
        print HTML "<td bgcolor=\"$color\">$qtpass<\/td><td bgcolor=\"$color\">$qtfail<\/td><td bgcolor=\"$color\">$qtnot_run<\/td>";
    } else {
        if (($failinfo)) {
           print HTML "<td>$qtpass<\/td><td nowrap>$qtfail <font color=\"red\">($failinfo)</font><\/td><td>$qtnot_run<\/td>";
        }
        else
        {
            print HTML "<td>$qtpass<\/td><td>$qtfail<\/td><td>$qtnot_run<\/td>";
        }

    }
    print HTML "<td bgcolor=\"$color\">$qtpass_rate<\/td>";
}

sub get_sct_ft_test_results
{
    #2DSP
    print HTML "<tr><td rowspan=\"2\">FSMr3-L1DSP<\/td><td rowspan=\"2\">2DSP<\/td>";
    #1pipe2dsp
    my ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_1pipe2dsp_test_path", "regression_test_result.txt", 0);
    my ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_1pipe2dsp_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 1PIPE","1pipe2dsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
    #2pipe2dsp
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_2pipe2dsp_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_2pipe2dsp_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 2PIPE","2pipe2dsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
    
    #3DSP
    print HTML "<tr><td rowspan=\"7\">FSMr3-UL8DSP-DL8DSP<\/td>";
    print HTML "<td rowspan=\"3\">3DSP<\/td>";
    #2pipe3dsp
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_2pipe3dsp_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_2pipe3dsp_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 2PIPE","2pipe3dsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
    #4pipe3dsp
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_4pipe3dsp_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_4pipe3dsp_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 4PIPE","4pipe3dsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
    #8pipe3dsp
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_8pipe3dsp_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_8pipe3dsp_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 8PIPE","8pipe3dsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
    print HTML "<td rowspan=\"1\">5DSP<\/td>";
    #supercell
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_supercell_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_supercell_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL SUPERCELL","supercell","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    print HTML "<td rowspan=\"2\">6DSP<\/td>";
    #new4Rx2Cell
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_new4Rx2Cell_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_new4Rx2Cell_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("2CELL 4PIPE","new4Rx2Cell","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
    # 8rx2cell
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_8rx2cell_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_8rx2cell_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("2CELL 8PIPE","8Rx2Cell","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    print HTML "<td rowspan=\"1\">9DSP<\/td>";
    #new8Rx3Cell
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_new8Rx3Cell_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_new8Rx3Cell_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("3CELL 8PIPE","new8Rx3Cell","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    
    #FZM
    print HTML "<tr><td rowspan=\"2\">FZM-L1L2DSP<\/td><td rowspan=\"2\">Single Cell Basic<\/td>";
    #fzm1pipe
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fzm1pipe_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fzm1pipe_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 1PIPE","fzm1pipe","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
    #fzm2pipe
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fzm2pipe_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fzm2pipe_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 2PIPE","fzm2pipe","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
    #fzm2cell
    print HTML "<tr><td rowspan=\"1\">FZM-L1L1DSP<\/td><td rowspan=\"1\">SFN Basic<\/td>";
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fzm2cell_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fzm2cell_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("2CELL 2PIPE","fzm2cell","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";

    print HTML "<tr><td rowspan=\"2\">FZM-L1EXL2DSP<\/td><td rowspan=\"2\">Two Cell Basic<\/td>";
    #fzmonedsp2cell1pipe
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fzmonedsp2cell1pipe_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fzmonedsp2cell1pipe_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("2CELL 1PIPE","fzmonedsp2cell1pipe","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
    #fzmonedsp2cell
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fzmonedsp2cell_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fzmonedsp2cell_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("2CELL 2PIPE","fzmonedsp2cell","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";

    #FZMASYM
    print HTML "<tr><td rowspan=\"3\">FZM-TASYMDSP<\/td><td rowspan=\"3\">Two Cell SDL<\/td>";
    #fzm1pipeasym
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fzm1pipeasym_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fzm1pipeasym_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 1PIPE","fzm1pipeasym","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
    #fzm2pipeasym
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fzm2pipeasym_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fzm2pipeasym_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 2PIPE","fzm2pipeasym","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
    #fzm2cellonedspasym
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fzm2cellonedspasym_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fzm2cellonedspasym_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("2CELL 2PIPE","fzm2cellonedspasym","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML "<\/tr>";
    
    #FSMR4
    print HTML "<tr><td rowspan=\"11\">FSMr4-ULDSP-DLDSP<\/td>";
    print HTML "<td rowspan=\"10\">One Pool<\/td>";
    #fsmr4 uldsp 1pipe
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_1pipe_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_1pipe_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 1PIPE","1pipefsmr4uldsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    #fsmr4 uldsp 2pipe
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2pipe_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2pipe_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 2PIPE","2pipefsmr4uldsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    #fsmr4 uldsp 4pipe
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_4pipe_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_4pipe_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 4PIPE","4pipefsmr4uldsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    #fsmr4 uldsp 8pipe
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_8pipe_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_8pipe_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 8PIPE","8pipefsmr4uldsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    #fsmr4 uldsp 2cell1pipe
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell1pipe_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell1pipe_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("2CELL 1PIPE","2cell1pipefsmr4uldsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    #fsmr4 uldsp 2cell2pipe
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell2pipe_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell2pipe_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("2CELL 2PIPE","2cell2pipefsmr4uldsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    #fsmr4 uldsp 2cell4pipe
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell4pipe_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell4pipe_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("2CELL 4PIPE","2cell4pipefsmr4uldsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    #fsmr4 uldsp 2cell8pipe
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell8pipe_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell8pipe_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("2CELL 8PIPE","2cell8pipefsmr4uldsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    #3cell1poolfsmr4uldsp
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_3cell1pool_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_3cell1pool_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("3CELL","3cell1poolfsmr4uldsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    #fsmr4 uldsp 2cell8pipecomp
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell8pipecomp_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_2cell8pipecomp_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("2CELL 8PIPE COMP","2cell8pipefsmr4uldspcomp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
    print HTML "<td rowspan=\"1\">Two Pool<\/td>";
    #fsmr4 uldsp 3cell4pipe
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_3cell4pipe_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4_uldsp_3cell4pipe_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("3CELL 4PIPE","3cell4pipefsmr4uldsp","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";

    #FSMr4L1MIMO
    # print HTML "<tr><td rowspan=\"1\">FSMr4-ULDSP-DLDSP-L1Call<\/td>";
    # fsmr4 uldsp 2cell4pipeulmimofsmr4
    # ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4_2cell4pipeulmimofsmr4_test_path", "regression_test_result.txt", 0);
    # ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4_2cell4pipeulmimofsmr4_test_path", "newfeature_test_result.txt", 0);
    # &print_sct_ft_content("2CELL 4PIPE","2cell4pipeulmimofsmr4","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    # print HTML"<\/tr>";
    
    #FSMr4mMIMO
    print HTML "<tr><td rowspan=\"1\">FSMr4-ULDSP-DLULDSP<\/td><td rowspan=\"1\">mMIMO<\/td>";
    ($regpass,$regfail,$regnot_run,$regpass_rate) = &get_test_results("$report_path/$sct_fsmr4mmimouldsp_test_path", "regression_test_result.txt", 0);
    ($newpass,$newfail,$newnot_run,$newpass_rate) = &get_test_results("$report_path/$sct_fsmr4mmimouldsp_test_path", "newfeature_test_result.txt", 0);
    &print_sct_ft_content("1CELL 64PIPE","fsmr4mmimo","regression.html",$regpass,$regfail,$regnot_run,$regpass_rate,"newfeature.html",$newpass,$newfail,$newnot_run,$newpass_rate);
    print HTML"<\/tr>";
}

sub print_sct_ft_content
{
    my ($anteType,$config_folder,$regLink,$regPass,$regFail,$regNotrun,$regPassrate,$newLink,$newPass,$newFail,$newNoutrun,$newPassrate) = @_;
    ($regPass,$regFail,$regNotrun,$regPassrate,$newPass,$newFail,$newNoutrun) = &sctandmt_abnormal($regPass,$regFail,$regNotrun,$regPassrate,$newPass,$newFail,$newNoutrun);
    my $color = "";
    my $nfcolor = "";
    if ($regPassrate eq 100)
    {
        $color = "#00FF00";
        $regPassrate = $regPassrate."\%";
    }
    elsif ($regPassrate eq "N/A") {
        $color = "#FF8000";
    }
    else
    {
        $color = "#FF0000";
        $regPassrate = $regPassrate."\%";
    }

    if ($newPassrate eq 100)
    {
        $nfcolor = "#00FF00";
    }
    elsif ($newPassrate eq "") {
        $nfcolor = "#FF8000";
    }
    else
    {
        $nfcolor = "#00FF00";
    }

    print HTML "<td bgcolor=\"#D8D8D8\">$anteType<\/td><td bgcolor=\"#D8D8D8\"><a href=\"$report_link\/SCT\/Test\/$config_folder\/$regLink\">LINK<\/a><\/td>";
    if ($regPassrate eq "N/A") {
        print HTML "<td bgcolor=\"$color\">$regPass<\/td><td bgcolor=\"$color\">$regFail<\/td><td bgcolor=\"$color\">$regNotrun<\/td>";
    } else {
        print HTML "<td>$regPass<\/td><td>$regFail<\/td><td>$regNotrun<\/td>";
    }

    print HTML "<td bgcolor=\"$color\">$regPassrate<\/td><td bgcolor=\"#D8D8D8\"><a href=\"$report_link\/SCT\/Test\/$config_folder\/$newLink\">LINK<\/a><\/td>";
    if ($newPassrate eq "") {
        print HTML "<td bgcolor=\"$nfcolor\">$newPass<\/td><td bgcolor=\"$nfcolor\">$newFail<\/td><td bgcolor=\"$nfcolor\">$newNoutrun<\/td>";
    } else {
        print HTML "<td>$newPass<\/td><td>$newFail<\/td><td>$newNoutrun<\/td>";
    }
}

sub print_footer
{
    my($report_link,$ulphy_link)=@_;
    open HTML, ">>${WORKSPACE}/${mailName}" or die "Could not open ${mailName} for writing.";
    print HTML "<p>&nbsp;<\/p><p><span style=\"font-family: \'Calibri\',\'sans-serif\'\" lang=EN-US>
        Logs:&nbsp;<\/span><a href=\"$report_link\"><span style=\"font: 6pt; color: #B43104;font-family: \'Calibri\',\'sans-serif\'\" lang=EN-US>$report_link<\/span><\/a><\/p>
        <p><a href=\"$ulphy_link\">Click here to go to the jenkins website.&nbsp;<\/a><\/p>
        <\/p>
        <p><a href=\"http:\/\/10.140.90.51:82\">Click here to go to SCT latency server to check latancy history.&nbsp;<\/a>
        <\/p>
        <p>&nbsp;<\/p>
        <p><i><span style=\"font-family: \'Calibri\',\'sans-serif\';line-height: 0.1\" lang=EN-US>Best regards,<\/span><\/i><\/p>
        <p><i><span style=\"font-family: \'Calibri\',\'sans-serif\';line-height: 0.1\" lang=EN-US>CI&TA Team<\/span><\/i><\/p>
        <\/body>";
    close HTML;
}

sub print_Klocwork_content
{
    my $file = shift;
    open TXT, "<$file" or die "Could not open file $file";

    my @lines = <TXT>;
    close TXT;
    if(@lines)
    {
        print HTML "
        <\/table>
        <h1>
        Klocwork Part:
        <\/h1>
        <table>
        <tr>
        <th>File<\/th>
        <th>New Issue Numbers<\/th>
        <\/tr>";
        foreach(@lines)
        {
            my @arr = split(/,/,$_);
            my $files = $arr[0];
            my $new_value = $arr[1];
            print HTML "<tr><td><b>$files<\/b><\/td><td class=\"fail\">$new_value<\/td><\/tr>\n";
        }
    }
}

sub print_static_analysis_content
{
    my $file = shift;
    open TXT, "<$file" or die "Could not open file $file";

    my @lines = <TXT>;
    close TXT;

    foreach(@lines)
    {
        my @arr = split(/,/,$_);
        my $filename = $arr[0];
        if ($file eq "$report_path/StaticAnalysis/Complexity/summary_cmt.txt")
        {
            my $functionname = $arr[1];
            my $new_value = $arr[2];
            my $old_value = $arr[3];
            my $base_value = $arr[4];
            my $result = "fail";
            my $old_link = $arr[6];
            my $new_link = $arr[5];
            if (($old_value ne "New Function") and ($new_value < $old_value))
            {
                $result = "pass";
            }

            print HTML "<tr><td><a href=\"${old_link}\">$old_value<\/a><\/td><td class=\"${result}\"><a href=\"${new_link}\">$new_value<\/a><\/td><td>$functionname<\/td><td style=\"word-break:break-all;word-wrap:break-all;\">$filename<\/td><\/tr>\n";
        }
        elsif ($file eq "$report_path/StaticAnalysis/Duplicity/summary_cpd.txt")
        {
            # $line,$new_cpd,$old_cpd,$base_cpd,"${newlink}duplicity_Report/","${oldlink}duplicity_Report/"
            my $new_value = $arr[1];
            my $old_value = $arr[2];
            my $base_value = $arr[3];
            my $new_line = $arr[4];
            my $old_line = $arr[5];

            my $result = "fail";
            if (($old_value ne "New File") and ($new_value < $old_value))
            {
                $result = "pass";
            }
            print HTML "<tr><td><a href=\"${old_line}\"><b>$old_value<\/b><\/a><\/td><td class=\"${result}\"><a href=\"${new_line}\"><b>$new_value<\/b><\/a><\/td><td>$filename<\/td><\/tr>\n";
        }
    }
}
sub print_git_log_content
{
    my $file = shift;
    open TXT, "<$file" or die "Could not open file $file";

    my @lines = <TXT>;
    close TXT;
    foreach my $line (@lines)
    {
       print HTML "$line<br>";
    }
}

sub get_case_number
{
    my $case_list_file = shift;
    my $case_number = `cat ${case_list_path}/*${case_list_file}[._]*txt | grep -Eo "#?\\-\\-test" | grep -v "^#" | wc -l`;

    return $case_number;
}
