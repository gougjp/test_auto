from PyQt5.QtCore import QThread, pyqtSignal, QDateTime
from PyQt5.QtWidgets import QApplication, QDialog, QLineEdit
import sys
import time

class BackendThread(QThread):
    update_date = pyqtSignal(str)
    
    def run(self):
        while True:
            data = QDateTime.currentDateTime()
            currTime = data.toString('yyyy-MM-dd hh:mm:ss')
            self.update_date.emit(str(currTime))
            time.sleep(1)
            
class Window(QDialog):
    def __init__(self):
        QDialog.__init__(self)
        self.setWindowTitle('PyQt 5 界面实时更新例子')
        self.resize(400, 100)
        
        self.input = QLineEdit(self)
        self.input.resize(400, 100)
        self.initUI()
        
    def initUI(self):
        self.backend = BackendThread()
        self.backend.update_date.connect(self.handleDispaly)
        self.backend.start()
        
    def handleDispaly(self, data):
        self.input.setText(data)
        
if __name__ == '__main__':
    app = QApplication(sys.argv)
    win = Window()
    win.show()
    sys.exit(app.exec_())