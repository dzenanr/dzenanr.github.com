class MenuBar {
  
  final Board board;
  
  // File
  ButtonElement saveAsPngButton;
  
  // Edit
  ButtonElement selectAllButton;
  ButtonElement deleteSelectionButton;
  
  // View
  ButtonElement increaseSelectionHeightButton;
  ButtonElement decreaseSelectionHeightButton;
  ButtonElement increaseSelectionWidthButton;
  ButtonElement decreaseSelectionWidthButton;
  ButtonElement increaseSelectionSizeButton;
  ButtonElement decreaseSelectionSizeButton;
  ButtonElement hideSelectionButton;
  ButtonElement showHiddenSelectionButton;
  
  // Utility
  ButtonElement createBoxesInDiagonalButton;
  ButtonElement createBoxesAsTilesButton;
  
  MenuBar(this.board) {  
    saveAsPngButton = document.query('#save-as-png');
    
    selectAllButton = document.query('#select-all');
    deleteSelectionButton = document.query('#delete-selection');
    
    increaseSelectionHeightButton = document.query('#increase-selection-height');
    decreaseSelectionHeightButton = document.query('#decrease-selection-height');
    increaseSelectionWidthButton = document.query('#increase-selection-width');
    decreaseSelectionWidthButton = document.query('#decrease-selection-width');
    increaseSelectionSizeButton = document.query('#increase-selection-size');
    decreaseSelectionSizeButton = document.query('#decrease-selection-size');
    hideSelectionButton = document.query('#hide-selection');
    showHiddenSelectionButton = document.query('#show-hidden-selection');
    
    createBoxesInDiagonalButton = document.query('#create-boxes-in-diagonal');
    createBoxesAsTilesButton = document.query('#create-boxes-as-tiles');
    
    // Menu bar events.
    saveAsPngButton.on.click.add((MouseEvent e) {
      board.saveAsPng();
    });
    
    selectAllButton.on.click.add((MouseEvent e) {
      board.select();
    });
    deleteSelectionButton.on.click.add((MouseEvent e) {
      board.deleteSelection();
    });
    
    increaseSelectionHeightButton.on.click.add((MouseEvent e) {
      board.increaseHeightOfSelectedBoxes();
    });
    decreaseSelectionHeightButton.on.click.add((MouseEvent e) {
      board.decreaseHeightOfSelectedBoxes();
    });
    increaseSelectionWidthButton.on.click.add((MouseEvent e) {
      board.increaseWidthOfSelectedBoxes();
    });
    decreaseSelectionWidthButton.on.click.add((MouseEvent e) {
      board.decreaseWidthOfSelectedBoxes();
    });
    increaseSelectionSizeButton.on.click.add((MouseEvent e) {
      board.increaseSizeOfSelectedBoxes();
    });
    decreaseSelectionSizeButton.on.click.add((MouseEvent e) {
      board.decreaseSizeOfSelectedBoxes();
    });
    hideSelectionButton.on.click.add((MouseEvent e) {
      board.hideSelection();
    });
    showHiddenSelectionButton.on.click.add((MouseEvent e) {
      board.showHiddenSelection();
    });
    
    createBoxesInDiagonalButton.on.click.add((MouseEvent e) {
      board.createBoxesInDiagonal();
      //board.printBoxNames();
    });
    createBoxesAsTilesButton.on.click.add((MouseEvent e) {
      board.createBoxesAsTiles();
    });
  }

}
