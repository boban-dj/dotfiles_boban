;
; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; EZ Improver script  for GIMP 2.4
; Original author: Mark Lowry
;
; Tags: photo, effect
;
; Author statement:
;
; A GIMP script-fu to perform a quick improvement
; to dingy, slightly underexposed images.
;
; Creates a top layer set to Saturation mode and
; a second layer set to Screen mode.
;
; If you leave the "Merge Layers" box unchecked,
; the two layers will remain on the stack and you can
; adjust the opacity of the Screen layer to suit,
; then merge down if desired.
;
; With the "Merge Layers" box checked, the layers will
; automatically merge down, and the resulting layer name
; will be "Fixed with EZ Improver".  If you have several
; similar images to adjust, you may wish to determine the
; desired opacity manually on the first image, then check
; the "Merge Layers" box to speed things up on the rest of
; the layers.  The script-fu input parameters are retained
; from one run to the next, so you won't have to change the
; opacity slider once you get it set the way you want it.
;
; --------------------------------------------------------------------
; Distributed by Gimp FX Foundry project
; --------------------------------------------------------------------
;   - Changelog -
; Created on 5/22/2006 for v.2.2.8
; Revised on 10/27/2007 to fix unbound variables (required for v.2.4.0).  Only tested on v.2.4.0
;
; --------------------------------------------------------------------
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




(define (script-fu-EZImprover  img drawable merge-flag )

   (let* (
       (screen-layer 0)
       (sat-layer 0)
         (second-merge 0)
         )


   ; Start an undo group.  Everything between the start and the end
   ; will be carried out if an undo command is issued.

   (gimp-image-undo-group-start img)

   ;; CREATE THE SCREEN LAYER ;;

   ; Create a new layer

   (set! screen-layer (car (gimp-layer-copy drawable 0)))

   ; Give it a name

   (gimp-drawable-set-name screen-layer "Adjust opacity, then merge this layer down first")

   ; Add the new layer to the image

   (gimp-image-add-layer img screen-layer 0)

   ; Set opacity to 100%

   (gimp-layer-set-opacity screen-layer 100)

   ; Set the layer mode to Screen

   (gimp-layer-set-mode screen-layer SCREEN-MODE )

   ;
   ;

   ;; CREATE THE SATURATION LAYER ;;

   (set! sat-layer (car (gimp-layer-copy drawable 0)))

   ; Give it a name

   (gimp-drawable-set-name sat-layer "Merge this layer down second")

   ; Add the new layer to the image

   (gimp-image-add-layer img sat-layer 0)

   ; Set opacity to 100%

   (gimp-layer-set-opacity sat-layer 100 )

   ; Set the layer mode to Saturation

   (gimp-layer-set-mode sat-layer SATURATION-MODE )

   ;
   ;

   ; NOW MERGE EVERYTHING DOWN IF DESIRED

   (if (equal? merge-flag TRUE)

      (gimp-image-merge-down img screen-layer 1 )

      ()

   )

   (if (equal? merge-flag TRUE)

       (set! second-merge (car(gimp-image-merge-down img sat-layer 1 )))

       ()
   )

   (if (equal? merge-flag TRUE)

       (gimp-drawable-set-name second-merge "Fixed with EZ Improver")

       ()

   )

   ; Complete the undo group

   (gimp-image-undo-group-end img)

   ; Flush the display

   (gimp-displays-flush)

   )

)


(script-fu-register "script-fu-EZImprover"

      "<Image>/FX-Foundry/Photo/Enhancement/EZ Improver"

      "Add screen layer and a saturation layer.  Works best on photos described as 'dingy' or 'dull'."

      "Mark Lowry"

      "Script by Mark Lowry"

      "2007"

      "RGB*, GRAY*"

      SF-IMAGE "Image" 0

      SF-DRAWABLE "Current Layer" 0

      SF-TOGGLE "Merge Layers?"  FALSE

 )

