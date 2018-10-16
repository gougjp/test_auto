

import warnings

with warnings.catch_warnings():
    warnings.filterwarnings("ignore", category = DeprecationWarning)
    import MimeWriter

import os, sys, traceback, re

currentPath = os.path.dirname(os.path.realpath(__file__))
sys.path.append(currentPath + os.sep + 'externals')

import time

import Svg
import GlobalVariables
from CommonFunctions import *
import BtsExceptions
import UdpLogger
from robot.libraries.BuiltIn import BuiltIn
import odict
from ExtCommon import *
import environ

c_outputParserSize = 20480

c_mscMagnifier = 2

c_mscDefaults = {"c_mscUnitWidth" : 60,
                 "c_mscUnitHeight" : 30,
                 "c_mscBoarder" : 10,
                 "c_mscUnitSpacing" : 90,
                 "c_mscMessageSpacing" : 30,
                 "c_mscFontSize" : 7,
                 "c_mscArrowVertIndent" : 3,
                 "c_mscArrowHorIndent" : 7,
                 "c_mcsUnitAddressHorIndent" : 8,
                 "c_mcsUnitAddressVertIndent" : 7,
                 "c_mcsUnitAddressVertSpacing" : 10,
                 "c_mscMessageNameHorIndent" : 10,
                 "c_mscMessageNameVertIndent" : 5}

c_mscUnitWidth = c_mscDefaults["c_mscUnitWidth"] * c_mscMagnifier
c_mscUnitHeight = c_mscDefaults["c_mscUnitHeight"] * c_mscMagnifier
c_mscBoarder = c_mscDefaults["c_mscBoarder"] * c_mscMagnifier
c_mscUnitSpacing = c_mscDefaults["c_mscUnitSpacing"] * c_mscMagnifier
c_mscMessageSpacing = c_mscDefaults["c_mscMessageSpacing"] * c_mscMagnifier
c_mscFontSize = c_mscDefaults["c_mscFontSize"] * c_mscMagnifier
c_mscArrowVertIndent = c_mscDefaults["c_mscArrowVertIndent"] * c_mscMagnifier
c_mscArrowHorIndent = c_mscDefaults["c_mscArrowHorIndent"] * c_mscMagnifier
c_mcsUnitAddressHorIndent = c_mscDefaults["c_mcsUnitAddressHorIndent"] * c_mscMagnifier
c_mcsUnitAddressVertIndent = c_mscDefaults["c_mcsUnitAddressVertIndent"] * c_mscMagnifier
c_mcsUnitAddressVertSpacing = c_mscDefaults["c_mcsUnitAddressVertSpacing"] * c_mscMagnifier
c_mscMessageNameHorIndent = c_mscDefaults["c_mscMessageNameHorIndent"] * c_mscMagnifier
c_mscMessageNameVertIndent = c_mscDefaults["c_mscMessageNameVertIndent"] * c_mscMagnifier

envcloudSctHead = """
<style type='text/css'>
table{
    border-collapse: collapse;
    }
table tr td{
    empty-cells: show
    width:100%;
    border-spacing:0;
    border: 1px solid;
}
</style>
</br>
<table>
<tr bgcolor='#D8D8D8'><td>CaseName</td><td>Status</td><td>Udplog</td><td>UserStatic</td></tr>
"""
envcloudMtHead = """
<style type='text/css'>
table{
    border-collapse: collapse;
    }
table tr td{
    empty-cells: show
    width:100%;
    border-spacing:0;
    border: 1px solid;
}
</style>
</br>
<table>
<tr bgcolor='#D8D8D8'><td>CaseName</td><td>Status</td><td>Udplog</td><td>Output</td></tr>
"""
'''
Used for signaling to test setup scripts if test listener fails so that test
suite and test case execution can be stopped.
'''
envcloudFoot = """
</table>
"""
unstableCaseList= currentPath +os.sep+".."+os.sep +"unstableCaseList.txt"
caseStartTime=""
caseEndTime=""
def writeFailEnvInfo(envfile):
    pduControlPort = environ.getenv_system('PDU_PORT')
    pduControlServer = environ.getenv_system('PDU_SERVER')
    pduControlIP = environ.getenv_system('PDU_IP')
    envfile.write("pduControlServer:"+pduControlServer+"pduControlIP:"+pduControlIP+"pduControlPort:"+pduControlPort+"\n")

def writeAllPassdCases(passdCasesFd, caseName, status, startTime, endTime):
    globalVariables = GlobalVariables.GlobalVariables()
    v_envRootPath = globalVariables.get_env_variable('${ENV_ROOT}')
    needIgnoreCases = open(os.path.join(v_envRootPath, 'ci', 'ft_ignore_case.txt')).readlines()
    needIgnoreCases = [case.strip() for case in needIgnoreCases]
    if caseName not in needIgnoreCases:
        passdCasesFd.write('%s,%s,%s,%s\n' % (caseName, status, startTime, endTime))

def writeSummaryFile(testType, summaryFd, allPassCasesFd, p_name, p_attrs, StartTime, EndTime):
    globalVariables = GlobalVariables.GlobalVariables()
    caseNamePostfix = globalVariables.get_env_variable("${TESTNAME_POSTFIX}")

    if testType == "MT":
        caseDeployment = globalVariables.get_env_variable("${TARGET_DEPLOYMENT}")
        if caseDeployment in ["mt_kepler", "mt_kepler_asym", "mt_fsmr4uldsp"]:
            if p_attrs["status"] =="FAIL":
                summaryFd.write('%s,%s,%s,%s\n' % (p_name+"_"+caseNamePostfix,p_attrs["status"]+":"+p_attrs["message"].replace("\n"," "), StartTime, EndTime))
                writeAllPassdCases(allPassCasesFd, p_name+"_"+caseNamePostfix, p_attrs["status"]+":"+p_attrs["message"].replace("\n"," "), StartTime, EndTime)
            else:
                summaryFd.write('%s,%s,%s,%s\n' % (p_name+"_"+caseNamePostfix,p_attrs["status"], StartTime, EndTime))
                writeAllPassdCases(allPassCasesFd, p_name+"_"+caseNamePostfix, p_attrs["status"], StartTime, EndTime)
        else:
            if p_attrs["status"] =="FAIL":
                summaryFd.write('%s,%s,%s,%s\n' % (p_name,p_attrs["status"]+":"+p_attrs["message"].replace("\n"," "), StartTime, EndTime))
                writeAllPassdCases(allPassCasesFd, p_name, p_attrs["status"]+":"+p_attrs["message"].replace("\n"," "), StartTime, EndTime)
            else:
                summaryFd.write('%s,%s,%s,%s\n' % (p_name,p_attrs["status"], StartTime, EndTime))
                writeAllPassdCases(allPassCasesFd, p_name, p_attrs["status"], StartTime, EndTime)
    elif testType == "SCT":
        if p_attrs["status"] =="FAIL":

            reason = p_attrs["message"].replace("\n"," ")
            if re.match(r'Data flow is failed.*',reason):
                reason = "Data flow is failed!"
            summaryFd.write('%s,%s,%s,%s\n' % (p_name+'_'+caseNamePostfix,p_attrs["status"]+":"+reason, StartTime, EndTime))
            writeAllPassdCases(allPassCasesFd, p_name+'_'+caseNamePostfix, p_attrs["status"]+":"+reason, StartTime, EndTime)
        else:
            summaryFd.write('%s,%s,%s,%s\n' % (p_name+'_'+caseNamePostfix,p_attrs["status"], StartTime, EndTime))
            writeAllPassdCases(allPassCasesFd, p_name+'_'+caseNamePostfix, p_attrs["status"], StartTime, EndTime)

#The following three funcitons are temporary, It's a workaround for tested count mismatch less than 2 and has "Symbol lost" udplog.
def haveTestCountMismatch(failInfo):
    failinfo=False
    for lineStr in failInfo.split('\n'):
        if re.match(r'Delay violation : Ue Index|Rejected count non-zero : Ue Index|.*Message content over the limit has been removed', lineStr):
            continue
        mTestCount = re.search(r'Failed count non-zero : Ue Index - (.*) .*.failedCount is (.*)', lineStr)
        if mTestCount and str(mTestCount.group(1)) in ["14","15","16","17","18","19"]:
            failinfo= True
        else:
            return False
    return failinfo

def checkUdpLog(udpLog):
    if not os.path.exists(udpLog):
        print 'Udplog file: ${udplog} is not exists!'.format(udplog=udpLog)
        return False

    with open(udpLog) as fUdpLog:
        for lineLog in fUdpLog:
            if 'Symbol lost' in lineLog:
                print lineLog
                return True

    return False

def haveRp3SymbolMissing(p_attrs):
    failInfo = p_attrs['message']
    caseName = p_attrs['longname']
    if haveTestCountMismatch(failInfo):
        return True
    return False

def getUnstableCaseInfo(v_testCase):
    return True if len(re.findall(v_testCase,open(unstableCaseList).read()))!=0 else False



def _set_failure(wrapped):
    def wrapper(self, *args, **kwargs):
        try:
            return wrapped(self, *args, **kwargs)
        except:
            exc_info = sys.exc_info() # Store exception and stack trace.
            print "*DEBUG*:exc_info,",exc_info,wrapped
            try:
                fatal = GlobalVariables.GlobalVariables().get_env_variable('${TEST_LISTENER_FAILURE_IS_FATAL}', True)
                fatal = convert_to_bool(fatal)
                if fatal:
                    BuiltIn().get_library_instance("TestListenerHelper").set_failure()
            except:
                '''
                After setting the failure flag once, wrapped function may still
                get executed by other test suite/case setups/teardowns.
                TestListenerHelper seems to become unavailable after the first
                failure, so the resulting exceptions are ignored.
                '''
                pass
            '''
            'raise' alone cannot be used here because it could re-raise an
            exception that was ignored in the 'pass' above, which would hide the
            original exception and its stack trace.
            '''
            raise exc_info[0], exc_info[1], exc_info[2]
    return wrapper

class TestListener:

    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self):
        self.__testCaseResults = odict.odict()
        self._udpLogger = None

        globalVariables = GlobalVariables.GlobalVariables()
        reportPath = globalVariables.get_env_variable("${ENV_REPORTPATH}")
        self.caseDeployment = globalVariables.get_env_variable("${TARGET_DEPLOYMENT}")
        self.testType = globalVariables.get_env_variable("${TEST_TYPE}")
        resultSummaryFile = os.path.join(reportPath,'summary.txt')
        envfile = os.path.join(reportPath,'envfile.txt')
        envcloud = os.path.join(reportPath,'envcloud.html')
        fatalCase = os.path.join(reportPath,'fatalCase.txt')
        self.envfileHandle = open(envfile, 'a')
        self.summaryHandle = open(resultSummaryFile, 'a')
        self.allPassCasesHandle = open(os.path.join(reportPath, 'allPassCases.txt'), 'a')
        self.fatalCase = open(fatalCase, 'a')
        self.envcloud = open(envcloud, 'a')
        if os.getenv("DEPLOYMENT") in ["MT_ALL", "MT_FZM", "MT_FSMR4", "MT_FSMR4ULDSP"]:
            self.envcloud.write(envcloudMtHead)
        else:
            self.envcloud.write(envcloudSctHead)

    def __draw_msc(self, p_testcaseName, p_ignoreTaskId = True):
        globalVariables = GlobalVariables.GlobalVariables()
        v_messagesPool = globalVariables.get_env_variable("${MESSAGE_POOL}")
        caseNamePostfix = globalVariables.get_env_variable("${TESTNAME_POSTFIX}")
        v_numberOfSentMessages = len(v_messagesPool)
        v_unitAddressList = []
        for i_messageItem in v_messagesPool:
            v_unitAddress = i_messageItem["sender"]
            if p_ignoreTaskId:
                v_unitAddress["task"] = 0
            if not v_unitAddress in v_unitAddressList:
                v_unitAddressList.append(v_unitAddress)
            v_unitAddress = i_messageItem["receiver"]
            if p_ignoreTaskId:
                v_unitAddress["task"] = 0
            if not v_unitAddress in v_unitAddressList:
                v_unitAddressList.append(v_unitAddress)
        v_numberOfUnits = len(v_unitAddressList)
        v_drawBoard = Svg.Scene("Message Sequence Chart",
                                2 * c_mscBoarder + c_mscUnitHeight + (v_numberOfSentMessages + 2) * c_mscMessageSpacing,
                                2 * c_mscBoarder + v_numberOfUnits * (c_mscUnitWidth + c_mscUnitSpacing) - c_mscUnitSpacing)
        # Drawing unit boxes
        for i_mscUnit in v_unitAddressList:
            v_unitLeft = c_mscBoarder + v_unitAddressList.index(i_mscUnit) * (c_mscUnitWidth + c_mscUnitSpacing)
            v_unitTop = c_mscBoarder
            v_drawBoard.add(Svg.Rectangle((v_unitLeft, v_unitTop),
                                          c_mscUnitHeight,
                                          c_mscUnitWidth,
                                          (255, 204, 0)))
            v_unitText = "board: 0x" + hex(arg_to_int(i_mscUnit["board"]))[2:].upper()
            v_drawBoard.add(Svg.Text((v_unitLeft + c_mcsUnitAddressHorIndent, v_unitTop + c_mcsUnitAddressVertIndent + c_mcsUnitAddressVertSpacing * 0),
                                     v_unitText,
                                     c_mscFontSize))
            v_unitText = "cpu: 0x" + hex(arg_to_int(i_mscUnit["cpu"]))[2:].upper()
            v_drawBoard.add(Svg.Text((v_unitLeft + c_mcsUnitAddressHorIndent, v_unitTop + c_mcsUnitAddressVertIndent + c_mcsUnitAddressVertSpacing * 1),
                                     v_unitText,
                                     c_mscFontSize))
            v_unitText = "task: 0x" + hex(arg_to_int(i_mscUnit["task"]))[2:].upper().zfill(4)
            v_drawBoard.add(Svg.Text((v_unitLeft + c_mcsUnitAddressHorIndent, v_unitTop + c_mcsUnitAddressVertIndent + c_mcsUnitAddressVertSpacing * 2),
                                     v_unitText,
                                     c_mscFontSize))
            v_drawBoard.add(Svg.Line((v_unitLeft + (c_mscUnitWidth / 2), v_unitTop + c_mscUnitHeight),
                                     (v_unitLeft + (c_mscUnitWidth / 2), c_mscBoarder + c_mscUnitHeight + (v_numberOfSentMessages + 2) * c_mscMessageSpacing)))
        # Drawing message lines
        for i_messageItem in v_messagesPool:
            v_senderIndex = v_unitAddressList.index(i_messageItem["sender"])
            v_receiverIndex = v_unitAddressList.index(i_messageItem["receiver"])
            v_senderLeft = c_mscBoarder + v_senderIndex * (c_mscUnitWidth + c_mscUnitSpacing)
            v_receiverLeft = c_mscBoarder + v_receiverIndex * (c_mscUnitWidth + c_mscUnitSpacing)
            v_lineSenderEnd = v_senderLeft + (c_mscUnitWidth / 2)
            v_lineReceiverEnd = v_receiverLeft + (c_mscUnitWidth / 2)
            v_lineTop = c_mscBoarder + c_mscUnitHeight + c_mscMessageSpacing * (v_messagesPool.index(i_messageItem) + 1)
            v_drawBoard.add(Svg.Line((v_lineSenderEnd, v_lineTop),
                                     (v_lineReceiverEnd, v_lineTop)))
            if v_lineReceiverEnd > v_lineSenderEnd:
                v_drawBoard.add(Svg.Line((v_lineReceiverEnd - c_mscArrowHorIndent, v_lineTop - c_mscArrowVertIndent),
                                         (v_lineReceiverEnd, v_lineTop)))
                v_drawBoard.add(Svg.Line((v_lineReceiverEnd - c_mscArrowHorIndent, v_lineTop + c_mscArrowVertIndent),
                                         (v_lineReceiverEnd, v_lineTop)))
                v_drawBoard.add(Svg.Text((v_lineSenderEnd + c_mscMessageNameHorIndent, v_lineTop - c_mscMessageNameVertIndent),
                                         i_messageItem["name"],
                                         c_mscFontSize,
                                         ".." + os.sep + i_messageItem["link"]))
            else:
                v_drawBoard.add(Svg.Line((v_lineReceiverEnd + c_mscArrowHorIndent, v_lineTop - c_mscArrowVertIndent),
                                         (v_lineReceiverEnd, v_lineTop)))
                v_drawBoard.add(Svg.Line((v_lineReceiverEnd + c_mscArrowHorIndent, v_lineTop + c_mscArrowVertIndent),
                                         (v_lineReceiverEnd, v_lineTop)))
                v_drawBoard.add(Svg.Text((v_lineReceiverEnd + c_mscMessageNameHorIndent, v_lineTop - c_mscMessageNameVertIndent),
                                         i_messageItem["name"],
                                         c_mscFontSize,
                                         ".." + os.sep + i_messageItem["link"]))
        v_testCase = globalVariables.get_env_variable("${TEST_NAME}")
        svgFolder = os.path.join(globalVariables.get_env_variable("${ENV_REPORTPATH}"),v_testCase + "_" + caseNamePostfix,"MessageChartFlow")
        if not os.path.exists(svgFolder):
            os.mkdir(svgFolder)
        # Save MSC to file
        v_drawBoard.write_svg(svgFolder + os.sep + "messageChartFlow.svg")


    @_set_failure
    def start_suite(self, p_name, p_attrs):
        # NOTE! Do not run any BuiltIn().run_keyword() inside this function or in functions called
        # in this function. Otherwise that keyword will be registered as suite setup keyword.
        globalVariables = GlobalVariables.GlobalVariables()
        #setup the UDP_logger in the beginning of the test
        if self._udpLogger is None:
            reportPath = globalVariables.get_env_variable("${ENV_REPORTPATH}")
            if reportPath is None:
                raise BtsExceptions.GeneralTestEnvironmentFault("${ENV_REPORTPATH} is not initialized")
            self._udpLogger = UdpLogger.UdpLogger(reportPath)
        test_logclosed = self._udpLogger.startUdpEntity(p_attrs["longname"])
        if not "." in p_attrs["longname"]:
            globalVariables.set_env_variable("${GLO_MESSAGE_POOL}", [])
            total = p_attrs["totaltests"]
            self.summaryHandle.write('TOTAL=%s\n' % total)

        if os.environ.has_key("WORKSPACE"):
            lastUsedTime = globalVariables.get_env_variable("${LAST_USED_TIME}", time.time())
            globalVariables.set_env_variable("${LAST_USED_TIME}", lastUsedTime)


    @_set_failure
    def start_test(self, p_name, p_attrs):
        REPORT_LANTANCY.clear()
        globalVariables = GlobalVariables.GlobalVariables()
        test_logclosed = self._udpLogger.startUdpEntity(p_attrs["longname"], isTestLog = True)
        messagePool = globalVariables.get_env_variable("${MESSAGE_POOL}")
        vCase = globalVariables.get_env_variable("${TEST_NAME}")
        global caseStartTime
        caseStartTime=time.time()
        self._udpLogger.caseLogsList.append(self._udpLogger.udpPortLogger.tmpReportFileName)

        if (messagePool is not None) and (len(messagePool) > 0):
            globalMessagePool = globalVariables.get_env_variable("${GLO_MESSAGE_POOL}", [])
            globalMessagePool.extend(messagePool)
            globalVariables.set_env_variable("${GLO_MESSAGE_POOL}", globalMessagePool)
        globalVariables.set_env_variable("${MESSAGE_POOL}", [])

        if self.testType == "SCT":
            reportPath           = globalVariables.get_env_variable("${ENV_REPORTPATH}")
            caseNamePostfix      = globalVariables.get_env_variable("${TESTNAME_POSTFIX}")
            statisticsFolderPath = os.path.join(reportPath, p_name + '_' + caseNamePostfix + os.sep +'Statistics')

            globalVariables.set_env_variable("${STATISTICS_PATH}",statisticsFolderPath)
            if not os.path.exists(statisticsFolderPath):
                os.makedirs(statisticsFolderPath)

    @_set_failure
    def end_test(self, p_name, p_attrs):
        globalVariables = GlobalVariables.GlobalVariables()
        v_status = ['FAIL']
        caseNamePostfix = globalVariables.get_env_variable("${TESTNAME_POSTFIX}")
        messagePool = globalVariables.get_env_variable("${MESSAGE_POOL}")
        if (messagePool is not None) and (len(messagePool) > 0):
            globalMessagePool = globalVariables.get_env_variable("${GLO_MESSAGE_POOL}", [])
            globalMessagePool.extend(messagePool)
            globalVariables.set_env_variable("${GLO_MESSAGE_POOL}", globalMessagePool)
            if self.testType != "MT":
                self.__draw_msc(p_attrs["longname"])
        v_testCaseTags = p_attrs["tags"]
        v_status[0:3] = [p_attrs["status"], p_attrs["message"], p_attrs["longname"].rsplit('.').pop()]

        self.__testCaseResults[p_attrs["longname"]] = v_status
        global caseStartTime
        caseEndTime=time.time()

        #write fatal case
        if p_attrs["status"] =="FAIL":
            self.fatalCase.write("--test "+p_name+"\n")

        #write env cloud

        test_name = globalVariables.get_env_variable("${TEST_NAME}")
        caseNamePostfix = globalVariables.get_env_variable("${TESTNAME_POSTFIX}")
        if os.getenv('ID') == None:
            testUser = "ruby"
        else:
            testUser = os.getenv('ID')
        envcloud = "/" if os.getenv("DEPLOYMENT") in ["MT_ALL", "MT_FZM", "MT_FSMR4", "MT_FSMR4ULDSP"] else "/Statistics/UserStatistics.html"
        fieldinfo = "outPut" if os.getenv("DEPLOYMENT") in ["MT_ALL", "MT_FZM", "MT_FSMR4", "MT_FSMR4ULDSP"] else "UserStatic"
        if 'Init_Environment' in test_name:
            htmllink   = "http://10.140.90.51:8081/userContent/envcloud/"+testUser+"/TA/INIT/log.html"
            udploglink = "http://10.140.90.51:8081/userContent/envcloud/"+testUser+"/TA/INIT/"+test_name+"_"+caseNamePostfix+"/udplog.html"
            UserStatic = ""
        else:
            htmllink   = "http://10.140.90.51:8081/userContent/envcloud/"+testUser+"/TA/log.html"
            udploglink = "http://10.140.90.51:8081/userContent/envcloud/"+testUser+"/TA/"+test_name+"_"+caseNamePostfix+"/udplog.html"
            UserStatic = "http://10.140.90.51:8081/userContent/envcloud/"+testUser+"/TA/"+test_name+"_"+caseNamePostfix+envcloud

        if p_attrs["status"] =="FAIL":
            self.envcloud.write("<tr><td><a href="+htmllink+">"+test_name+"</a></td><td bgcolor='#FF0000'>"+p_attrs["status"]+"</td><td><a href="+udploglink+">UDPLOG</a></td><td><a href="+UserStatic+">"+fieldinfo+"</a></td></tr>")

        else:
            self.envcloud.write("<tr><td><a href="+htmllink+">"+test_name+"</a></td><td bgcolor='#00FF00'>"+p_attrs["status"]+"</td><td><a href="+udploglink+">UDPLOG</a></td><td><a href="+UserStatic+">"+fieldinfo+"</a></td></tr>")


        if getUnstableCaseInfo(p_name + '_' + caseNamePostfix) and p_attrs["status"] =="FAIL":
            p_attrs["status"] = "UNSTABLE"
        if p_attrs["status"] =="FAIL" and (p_attrs["message"] in ["Test execution stopped due to a fatal error.","Setup failed: BTS reboot failed!","Setup failed: Please check if bts reboot by powerbreak for: Radio Time configuration failed with status = 1"]):
            writeFailEnvInfo(self.envfileHandle)

        if test_name=="TL17SP_CP_UDconf1_Format3_20M_MIMO_IRC_2Cell" and haveRp3SymbolMissing(p_attrs):
            p_attrs["status"] = "PASS"

        writeSummaryFile(self.testType, self.summaryHandle, self.allPassCasesHandle, p_name, p_attrs, int(caseStartTime), int(caseEndTime))
        self.sleepForSpecialCase()
        self._udpLogger.stopUdpEntity(p_attrs["longname"], isTestLog = True)
    def sleepForSpecialCase(self):
        test_name = GlobalVariables.GlobalVariables().get_env_variable("${TEST_NAME}")
        if test_name=="TM1212_Mixed_RI":
            time.sleep(25)

    @_set_failure
    def end_suite(self, p_name, p_attrs):
        globalVariables = GlobalVariables.GlobalVariables()

        if not "." in p_attrs["longname"]:
            messagePool = globalVariables.get_env_variable("${MESSAGE_POOL}")
            globalMessagePool = globalVariables.get_env_variable("${GLO_MESSAGE_POOL}", [])
            if (messagePool is not None) and (len(messagePool) > 0):
                globalMessagePool.extend(messagePool)
                globalVariables.set_env_variable("${GLO_MESSAGE_POOL}", globalMessagePool)
            globalVariables.set_env_variable("${MESSAGE_POOL}", globalMessagePool)
            print ""
            print "******************************************************************************************"
            print "Suite execution summary:"
            print ""
            v_longestNameLength = 0
            summaryString = ''
            for i_testCase in self.__testCaseResults.iterkeys():
                if len(i_testCase) > v_longestNameLength:
                    v_longestNameLength = len(i_testCase)
            for i_testCase in self.__testCaseResults.iterkeys():
                v_currentNameLength = len(i_testCase)
                v_currentName = i_testCase + "".join(" " for i_space in range(v_longestNameLength - v_currentNameLength + 1))
                if self.__testCaseResults[i_testCase][1]:
                    self.__testCaseResults[i_testCase][1] = self.__testCaseResults[i_testCase][1].lstrip().replace("\n", " ")

                    if len(self.__testCaseResults[i_testCase][1]) > 50:
                        extraDots = "..."
                    else:
                        extraDots = "..."
                    print v_currentName + " = " + self.__testCaseResults[i_testCase][0] + " (" + self.__testCaseResults[i_testCase][1][:50] + extraDots + ")"
                else:
                    print v_currentName + " = " + self.__testCaseResults[i_testCase][0]


            print ""
            print "******************************************************************************************"
            print ""

        self._udpLogger.stopUdpEntity(p_attrs["longname"])

    @_set_failure
    def close(self):
        if None != self._udpLogger:
            self._udpLogger.close()
        del self._udpLogger
        self._udpLogger = None
        self.summaryHandle.close()
        self.allPassCasesHandle.close()
        self.envcloud.write(envcloudFoot)
        self.envcloud.close()
        self.envfileHandle.close()


if __name__ == "__main__":
    print getUnstableCaseInfo("TC_MT_PUSCH_DATA_FLOW_8PIPE_CASE_Enhance_MRC")
