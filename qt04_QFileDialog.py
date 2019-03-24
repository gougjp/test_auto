import sys
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

class FileDialogDemo(QWidget):
    def __init__(self, parent=None):
        super(FileDialogDemo, self).__init__(parent)
        self.setWindowTitle('File Dialog例子')
        
        self.btn1 = QPushButton('加载图片')
        self.btn1.clicked.connect(self.getImageFile)
        
        self.le = QLabel('')
        
        self.btn2 = QPushButton('加载文本文件')
        self.btn2.clicked.connect(self.getTextFile)
        
        self.contents = QTextEdit()
        
        layout = QVBoxLayout()
        layout.addWidget(self.btn1)
        layout.addWidget(self.le)
        layout.addWidget(self.btn2)
        layout.addWidget(self.contents)
        self.setLayout(layout)
        
    def getImageFile(self):
        imageFile, _ = QFileDialog.getOpenFileName(self, 'Open File', 'C:\\', 'Image files (*.jpg *.gif)')
        self.le.setPixmap(QPixmap(imageFile))
        
    def getTextFile(self):
        dlg = QFileDialog()
        dlg.setFileMode(QFileDialog.AnyFile)
        dlg.setFilter(QDir.Files)
        
        if dlg.exec_():
            textFile = dlg.selectedFiles()
            f = open(textFile[0], 'r', encoding="utf-8")
            
            with f:
                data = f.read()
                self.contents.setText(data)
                
if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = FileDialogDemo()
    ex.show()
    sys.exit(app.exec_())
        


