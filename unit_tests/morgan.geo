; Morgan Library Auditorium
; Acoustic Model
; Brian FG Katz


; Hall is symmetrical
GLOBAL mirror_on = true	; set to false to turn off MIRROR function in geo files (easier to work with)
GLOBAL simple_geo = true	; use Simp GEO files for Wedge and Corner panels

GLOBAL seat_height = 1.0 	; height of seating bounding box
GLOBAL poff = 0.16	; panel offset from center mount

GLOBAL balcvtilt = -80	; vertical tilt angle of balc panels	default -3
GLOBAL wedgevtilt = 0	; vertical tilt angle of wedge panels
GLOBAL wang = 3.5		; wedge panel angle
GLOBAL cornervtilt = 0 	; vertical tilt angle of corner panels
GLOBAL cornerhtilt = 3.5 	; horizontal tilt angle of corner panels

INCLUDE ABSdefs.geo

;***** SELECT 1 wall panel configuration *****
INCLUDE WallPanelsD1.geo ; individual panels, ang defined along h and v
;INCLUDE WallPanelsD2.geo ; some grouped panels, ang defined along h and v

INCLUDE BoundarySurfaces.geo	; Base room

IF -simple_geo THEN
 INCLUDE WedgePanels.geo
 INCLUDE StageCornerPanels.geo
ENDIF
IF simple_geo THEN
 INCLUDE WedgePanels_Simp.geo
 INCLUDE StageCornerPanels_Simp.geo
ENDIF

INCLUDE balcony.geo	; needs info from WedgePanels

;**** Balcony front design
;INCLUDE BalconyPanels.geo
INCLUDE BalconyPanelsCurved.geo


;**** First stage ceiling panels
;INCLUDE Leaf0Center.geo
;INCLUDE Leaf0Side.geo
;INCLUDE Leaf0Center3.geo
INCLUDE Leaf0Center4.geo

;**** Center ceiling panels
;INCLUDE LeavesCenter.geo
;INCLUDE LeavesCenter_high.geo
;INCLUDE LeavesCenterRot.geo
;INCLUDE LeavesCenterRotClosure.geo
;INCLUDE LeavesCenter3.geo
INCLUDE LeavesCenter4.geo
INCLUDE LeavesCenter4a.geo

;**** Side ceiling panels
;INCLUDE LeavesSide.geo
;INCLUDE LeavesSide_high.geo



CORNERS

PLANES
