final String sketchname = getClass().getName();

import com.hamoid.*;
VideoExport videoExport;

void rec() {
  if (frameCount == 1) {
    if (fluctuation) videoExport = new VideoExport(this, "../"+sketchname+"_fluctuation.mp4");
    else videoExport = new VideoExport(this, "../"+sketchname+"_no_fluctuation.mp4");
    videoExport.setFrameRate(60);  
    videoExport.startMovie();
  }
  videoExport.saveFrame();
}
