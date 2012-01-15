class ToolBar {
  
  static final int SELECT = 1;
  static final int BOX = 2;
  static final int LINE = 3;
  
  final Board board;
  
  int _onTool;
  int _fixedTool;
  
  ButtonElement selectButton;
  ButtonElement boxButton;
  ButtonElement lineButton;
  InputElement canvasWidthInput;
  InputElement canvasHeightInput;
  
  InputElement boxNameInput;
  InputElement boxEntryCheckbox;
  InputElement itemNameInput;
  OptionElement itemOption;
  InputElement itemInitInput;
  ButtonElement addItemButton;
  ButtonElement getItemButton;
  ButtonElement upItemButton;
  ButtonElement downItemButton;
  ButtonElement setItemButton;
  ButtonElement removeItemButton;
  
  Item currentItem;
  
  OptionElement lineOption;
  InputElement lineInternalCheckbox;
  ButtonElement getLineButton;
  ButtonElement setLineButton;
  
  LabelElement line12Box1Label;
  LabelElement line12Box2Label;
  InputElement line12MinInput;
  InputElement line12MaxInput;
  InputElement line12IdCheckbox;
  InputElement line12NameInput;
  
  LabelElement line21Box2Label;
  LabelElement line21Box1Label;
  InputElement line21MinInput;
  InputElement line21MaxInput;
  InputElement line21IdCheckbox;
  InputElement line21NameInput;
  
  ToolBar(this.board) {
    selectButton = document.query('#select');
    boxButton = document.query('#box');
    lineButton = document.query('#line');
    
    // Tool bar events.
    selectButton.on.click.add((MouseEvent e) {
      onTool(SELECT);
    });
    selectButton.on.dblClick.add((MouseEvent e) {
      onTool(SELECT);
      _fixedTool = SELECT;
    });
    
    boxButton.on.click.add((MouseEvent e) {
      onTool(BOX);
    });
    boxButton.on.dblClick.add((MouseEvent e) {
      onTool(BOX);
      _fixedTool = BOX;
    });
    
    lineButton.on.click.add((MouseEvent e) {
      onTool(LINE);
    });
    lineButton.on.dblClick.add((MouseEvent e) {
      onTool(LINE);
      _fixedTool = LINE;
    });
    
    onTool(SELECT);
    _fixedTool = SELECT;
    
    canvasWidthInput = document.query('#canvasWidth');
    canvasHeightInput = document.query('#canvasHeight');
    canvasWidthInput.valueAsNumber = board.width;
    canvasWidthInput.on.input.add((Event e) {
      board.width = canvasWidthInput.valueAsNumber;
    });
    canvasHeightInput.valueAsNumber = board.height;
    canvasHeightInput.on.input.add((Event e) {
      board.height = canvasHeightInput.valueAsNumber;
    });
    
    boxNameInput = document.query('#boxName');
    boxNameInput.on.focus.add((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        boxNameInput.value = box.title;
        boxEntryCheckbox.checked = box.entry;
        currentItem = null;
        itemNameInput.value = '';
        itemOption.value = 'attribute';
        itemInitInput.value = '';
      }
    });
    boxNameInput.on.input.add((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        String boxName = boxNameInput.value.trim();
        if (boxName != '') {
          Box otherBox = board.findBox(boxName);
          if (otherBox == null) {
            box.title = boxName;
          }
        }
      }
    });
    
    boxEntryCheckbox = document.query('#boxEntry');
    boxEntryCheckbox.on.change.add((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        box.entry = boxEntryCheckbox.checked;
      }
    });
    
    itemNameInput = document.query('#itemName');
    
    itemOption = document.query('#itemCategory');
    itemOption.on.change.add((MouseEvent e) {
      if (currentItem != null) {
        currentItem.name = itemNameInput.value;
        currentItem.category = itemOption.value;
        itemNameInput.select();
      } 
      itemInitInput.value = '';
    });
    
    itemInitInput = document.query('#itemInit');
    
    addItemButton = document.query('#addItem');
    addItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        String itemName = itemNameInput.value.trim();
        if (itemName != '') {
          Item otherItem = box.findItem(itemName);
          if (otherItem == null) {
            Item item = new Item(box, itemName, itemOption.value);
            item.init = itemInitInput.value.trim();
          }
        }
      }
    });
    
    getItemButton = document.query('#getItem');
    getItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        Item item = box.findItem(itemNameInput.value);
        if (item != null) {
          currentItem = item;
          itemNameInput.value = item.name;
          itemOption.value = item.category;
          itemInitInput.value = item.init;
          itemNameInput.select();
        } else {
          currentItem = null;
        }
      }
    });
    
    upItemButton = document.query('#upItem');
    upItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          Item previousItem = box.findPreviousItem(currentItem);
          if (previousItem != null) {
            int previousSequence = previousItem.sequence;
            int currentSequence = currentItem.sequence;
            currentItem.sequence = previousSequence;
            previousItem.sequence = currentSequence;
            itemNameInput.select();
          } else {
            currentItem = null;
            itemNameInput.value = '';
            itemOption.value = 'attribute';
            itemInitInput.value = '';
          }
        } 
      }
    });
    
    downItemButton = document.query('#downItem');
    downItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          Item nextItem = box.findNextItem(currentItem);
          if (nextItem != null) {
            int nextSequence = nextItem.sequence;
            int currentSequence = currentItem.sequence;
            currentItem.sequence = nextSequence;
            nextItem.sequence = currentSequence;
            itemNameInput.select();
          } else {
            currentItem = null;
            itemNameInput.value = '';
            itemOption.value = 'attribute';
            itemInitInput.value = '';
          }
        }
      }
    });
    
    setItemButton = document.query('#setItem');
    setItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          String itemName = itemNameInput.value.trim();
          if (itemName != '') {
            Item otherItem = box.findItem(itemName);
            if (otherItem == null) {
              currentItem.name = itemName;
            }
          }
          currentItem.category = itemOption.value;
          currentItem.init = itemInitInput.value;
          itemNameInput.select();
        }
      }
    });
    
    removeItemButton = document.query('#removeItem');
    removeItemButton.on.click.add((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          if (box.removeItem(currentItem)) {
            currentItem = null;
            itemNameInput.value = '';
            itemOption.value = 'attribute';
            itemInitInput.value = '';
          }
        }
      }
    });
    
    lineOption = document.query('#lineCategory');
    lineOption.on.change.add((MouseEvent e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.category = lineOption.value;
        
        lineInternalCheckbox.checked = line.internal;
        
        line12Box1Label.text = line.box1.title;
        line12Box2Label.text = line.box2.title;
        line12MinInput.value = line.box1box2Min;
        line12MaxInput.value = line.box1box2Max;
        line12IdCheckbox.checked = line.box1box2Id;
        line12NameInput.value = line.box1box2Name;
        
        line21Box2Label.text = line.box2.title;
        line21Box1Label.text = line.box1.title;
        line21MinInput.value = line.box2box1Min;
        line21MaxInput.value = line.box2box1Max;
        line21IdCheckbox.checked = line.box2box1Id;
        line21NameInput.value = line.box2box1Name;
      }
    });
    
    lineInternalCheckbox = document.query('#lineInternal');
    lineInternalCheckbox.on.change.add((Event e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.internal = lineInternalCheckbox.checked;
        
        lineOption.value = line.category;
        
        line12Box1Label.text = line.box1.title;
        line12Box2Label.text = line.box2.title;
        line12MinInput.value = line.box1box2Min;
        line12MaxInput.value = line.box1box2Max;
        line12IdCheckbox.checked = line.box1box2Id;
        line12NameInput.value = line.box1box2Name;
        
        line21Box2Label.text = line.box2.title;
        line21Box1Label.text = line.box1.title;
        line21MinInput.value = line.box2box1Min;
        line21MaxInput.value = line.box2box1Max;
        line21IdCheckbox.checked = line.box2box1Id;
        line21NameInput.value = line.box2box1Name;
      }
    });
    
    getLineButton = document.query('#getLine');
    getLineButton.on.click.add((MouseEvent e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        lineOption.value = line.category;
        lineInternalCheckbox.checked = line.internal;
        
        line12Box1Label.text = line.box1.title;
        line12Box2Label.text = line.box2.title;
        line12MinInput.value = line.box1box2Min;
        line12MaxInput.value = line.box1box2Max;
        line12IdCheckbox.checked = line.box1box2Id;
        line12NameInput.value = line.box1box2Name;
        
        line21Box2Label.text = line.box2.title;
        line21Box1Label.text = line.box1.title;
        line21MinInput.value = line.box2box1Min;
        line21MaxInput.value = line.box2box1Max;
        line21IdCheckbox.checked = line.box2box1Id;
        line21NameInput.value = line.box2box1Name;
      }
    });
    
    setLineButton = document.query('#setLine');
    setLineButton.on.click.add((MouseEvent e) {
      Line line = board.lastLineSelected;
      if (line != null) {   
        line.box1box2Min = line12MinInput.value.trim();
        line.box1box2Max = line12MaxInput.value.trim();
        if (line.box1box2Min == '1' && line.box1box2Max == '1') {
          line.box1box2Id = line12IdCheckbox.checked;
        } else {
          line12IdCheckbox.checked = false;
          line.box1box2Id = false;
        }
        line.box1box2Name = line12NameInput.value.trim();
        
        line.box2box1Min = line21MinInput.value.trim();
        line.box2box1Max = line21MaxInput.value.trim();
        if (line.box2box1Min == '1' && line.box2box1Max == '1') {
          line.box2box1Id = line21IdCheckbox.checked;
        } else {
          line21IdCheckbox.checked = false;
          line.box2box1Id = false;
        }  
        line.box2box1Name = line21NameInput.value.trim();
      }
    });
    
    line12Box1Label = document.query('#line12Box1');
    line12Box2Label = document.query('#line12Box2');
    line12MinInput = document.query('#line12Min');
    line12MaxInput = document.query('#line12Max');
    line12IdCheckbox = document.query('#line12Id');
    line12NameInput = document.query('#line12Name');
    
    line21Box2Label = document.query('#line21Box2');
    line21Box1Label = document.query('#line21Box1');
    line21MinInput = document.query('#line21Min');
    line21MaxInput = document.query('#line21Max');
    line21IdCheckbox = document.query('#line21Id');
    line21NameInput = document.query('#line21Name');
  }
  
  onTool(int tool) {
    _onTool = tool;
    if (_onTool == SELECT) {
      selectButton.style.borderColor = Board.DEFAULT_LINE_COLOR; 
      boxButton.style.borderColor = Board.SOFT_LINE_COLOR;
      lineButton.style.borderColor = Board.SOFT_LINE_COLOR;
    } else if (_onTool == BOX) {
      selectButton.style.borderColor = Board.SOFT_LINE_COLOR;
      boxButton.style.borderColor = Board.DEFAULT_LINE_COLOR;
      lineButton.style.borderColor = Board.SOFT_LINE_COLOR;
    } else if (_onTool == LINE) {
      selectButton.style.borderColor = Board.SOFT_LINE_COLOR;
      boxButton.style.borderColor = Board.SOFT_LINE_COLOR;
      lineButton.style.borderColor = Board.DEFAULT_LINE_COLOR;
    }
  }
  
  bool isSelectToolOn() {
    if (_onTool == SELECT) {
      return true; 
    }
    return false;
  }
  
  bool isBoxToolOn() {
    if (_onTool == BOX) {
      return true; 
    }
    return false;
  }
  
  bool isLineToolOn() {
    if (_onTool == LINE) {
      return true; 
    }
    return false;
  }
  
  void backToFixedTool()  {
      onTool(_fixedTool);
  }
  
  void backToSelectAsFixedTool()  {
    onTool(SELECT);
    _fixedTool = SELECT;
  }
  
}
