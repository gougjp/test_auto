import sys
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

class FontDialogDemo(QWidget):
    def __init__(self, parent=None):
        super(FontDialogDemo, self).__init__(parent)
        self.setWindowTitle('Font Dialog例子')
        
        self.fontButton = QPushButton('choose font')
        self.fontButton.clicked.connect(self.getFont)
        self.fontLineEdit = QLabel('Hello, 测试字体例子')
        
        layout = QVBoxLayout()
        layout.addWidget(self.fontButton)
        layout.addWidget(self.fontLineEdit)
        self.setLayout(layout)
        
    def getFont(self):
        font, ok = QFontDialog.getFont()
        if ok:
            self.fontLineEdit.setFont(font)
            
if __name__ == '__main__':
    app = QApplication(sys.argv)
    demo = FontDialogDemo()
    demo.show()
    sys.exit(app.exec_())




