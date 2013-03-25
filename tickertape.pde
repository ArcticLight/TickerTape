float time;
double lastMillis;
String message;
String[] lines;
int messageNo;
PFont f;
int caratx;
float camerax;
final int FONTHEIGHT = 48;
final int WIDTH=800;
final int HEIGHT=200;
final int CARATHEIGHT = FONTHEIGHT+4;
final int CARATWIDTH = 4;
//when the next print will be,
//when the last print was.
float nextPrint, lastPrint;
//the number of characters printed out
int numPrinted;

void setup() {
    f = loadFont("font.vlw");
    size(WIDTH,HEIGHT);
    caratx = WIDTH/2;
    textFont(f);
    camerax = WIDTH/2;
    nextPrint = 0;
    lastPrint = 0;
    messageNo = 0;
    lines = loadStrings("messages.txt");
    message = lines[0];
}

void draw() {
    time += millis() - lastMillis;
    lastMillis = millis();
    
    background(0);
    translate(-camerax+WIDTH/2, 0);
    if(caratx - camerax > WIDTH/4)
        camerax += (caratx - camerax)/100;
    else
        camerax += (camerax < caratx)? 2 : 0;
    
    String toPrint = "";
    
    if(numPrinted > 0) {
        toPrint = message.substring(0,constrain(numPrinted, 1, message.length()));
    }
    
    if(time > nextPrint && numPrinted < message.length()) {
        numPrinted++;        
        toPrint = message.substring(0,constrain(numPrinted, 1, message.length()));
        char next = toPrint.charAt(toPrint.length() - 1);
        if( (next > 'A' && next < 'Z') || (next > 'a' && next < 'z') ) {
            nextPrint = time + 100;
        } else {
            switch(next) {
                case '1':
                case '2':
                case '3':
                case '4':
                case '5':
                case '6':
                case '7':
                case '8':
                case '9':
                case '0':
                case '(':
                case ')':
                case ':':
                    nextPrint = time + 100;
                    break;
                case ',':
                case '.':
                    nextPrint = time + 400;
                    break;
                case ' ':
                    nextPrint = time;
                    break;
                default:
                    nextPrint = time + 200;
            }
        }
        lastPrint = time;
    }
    if(numPrinted >= message.length() && (lastPrint+5000 < time) && messageNo + 1 < lines.length) {
        message = lines[++messageNo];
        numPrinted = 0;
        camerax = WIDTH/2;
        caratx = 0;
    }
    
    
    textAlign(LEFT, CENTER);
    final int MAXNUM = 30;
    int number = constrain(toPrint.length(), 0, MAXNUM);
    if(number > 1)
    for(int i = number; i > 0; i--) {
        fill(250-((number-i)*(255/MAXNUM) + (time - lastPrint)/80));
        text(toPrint.substring(toPrint.length() - (number-i+1), toPrint.length() - (number-i)), WIDTH/2 + textWidth(toPrint.substring(0, toPrint.length() - (number-i+1))), HEIGHT/2);
    }
    
    
    final int CARATTICK = 30;
    if( int(floor(time/CARATTICK)) % CARATTICK < CARATTICK/2 ) {
        caratx = floor(textWidth(toPrint)) + 8 + WIDTH/2;
        drawCarat();
    }
}

void drawCarat() {
    noStroke();
    fill(255);
    rectMode(CORNER);
    rect(caratx, HEIGHT/2 - FONTHEIGHT/2, CARATWIDTH, CARATHEIGHT);
}
