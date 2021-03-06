import sys
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

class MenuDemo(QMainWindow):
    def __init__(self, parent=None):
        super(MenuDemo, self).__init__(parent)
        self.setWindowTitle('menu例子')
        
        bar = self.menuBar()
        file = bar.addMenu('File')
        file.addAction('New')
        
        save = QAction('Save', self)
        save.setShortcut('Ctrl+S')
        file.addAction(save)
        
        edit = file.addMenu('Edit')
        edit.addAction('Copy')
        edit.addAction('Paste')
        
        quit = QAction('Quit', self)
        file.addAction(quit)
        file.triggered[QAction].connect(self.processtrigger)
        
        layout = QHBoxLayout()
        self.setLayout(layout)
        
    def processtrigger(self, q):
        print(q.text()+' is triggered')
        
if __name__ == '__main__':
    app = QApplication(sys.argv)
    demo = MenuDemo()
    demo.show()
    sys.exit(app.exec_())
        