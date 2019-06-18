-- 3DTrooper CamTools
-- V 0.3   02.03.2018
-- V 0.4   04.02.2019
-- V 0.5   07.05.2019 - fixed some minior bugs

if CamTools != undefined then
		(
			destroyDialog CamTools
		)
		
rollout CamTools "TDT Camera Tools" width:160 height:345
(
	
	button 'btn_Focus' "FocusGGGG" pos:[8,8] width:72 height:29 toolTip:"Focuses current or the selected camera" align:#left
	spinner 'spn_offset' "" pos:[96,21] width:56 height:16 range:[-5000,5000,0] align:#left
	GroupBox 'grp_CreateObjs' "Create Objects" pos:[4,43] width:144 height:13 align:#left
	button 'btn_ShootHelper' "ShootHelper" pos:[8,92] width:72 height:16 toolTip:"Shoots a point helper from the middle of the current View Port" align:#left
	button 'btn_ShootSpline' "ShootS" pos:[80,92] width:40 height:16 toolTip:"Shoots a spline from the middle of the current View Port" align:#left
	button 'btn_SetRenderResA' "1280x720" pos:[9,230] width:64 height:16 toolTip:"Set Render Resolution" align:#left
	button 'btn_SetRenderResB' "640x360" pos:[9,246] width:64 height:16 toolTip:"Set Render Resolution" align:#left
	GroupBox 'grp_SetCamTo' "Set Focal Length/Aspect" pos:[5,113] width:145 height:51 align:#left
	button 'btn_CreateRig' "Create Rig" pos:[8,57] width:72 height:16 toolTip:"Create a simple camera rig" align:#left
	button 'btn_SetFoVA' "24mm" pos:[9,127] width:48 height:16 toolTip:"Set Focal Length" align:#left
	button 'btn_SetFoVB' "80mm" pos:[105,127] width:48 height:16 toolTip:"Set Focal Length" align:#left
	button 'btn_SetFoVC' "36mm" pos:[57,127] width:48 height:16 toolTip:"Set Focal Length" align:#left
	edittext 'edt2' "" pos:[5,270] width:132 height:70 readOnly:true align:#left
	GroupBox 'grp3' "Add Controller/Keys" pos:[6,164] width:148 height:51 align:#left
	button 'btn_noiselayer' "Noise P" pos:[9,179] width:48 height:16 toolTip:"Add Noise Layer to Node (position)" align:#left
	button 'btn_RotLayer' "Rotation" pos:[81,179] width:72 height:16 toolTip:"Add Rotation Key Frames to Node" align:#left
	button 'btn_AspectB' "16:9" pos:[57,143] width:48 height:16 toolTip:"Set Aspect 16:9" align:#left
	button 'btn_AspectC' "2,35:1" pos:[105,143] width:48 height:16 toolTip:"Set Aspect 2,35:1" align:#left
	button 'btn_AspectA' "4:3" pos:[9,143] width:48 height:16 toolTip:"Set Aspect 4:3" align:#left
	button 'btn_ResMultiplierC' "x1.5" pos:[81,246] width:32 height:16 toolTip:"Multiply the current resolution by 1.5" align:#left
	button 'btn_ResMultiplierD' "/1.5" pos:[121,246] width:32 height:16 toolTip:"Divide the current resolution by 1.5" align:#left
	button 'btn_SceneInfo' "R" pos:[137,270] width:16 height:16 toolTip:"Refresh" align:#left
	button 'btn_ResMultiplierA' "x2" pos:[81,230] width:32 height:16 toolTip:"Multiply the current resolution by 2" align:#left
	button 'btn_ResMultiplierB' "/2" pos:[121,230] width:32 height:16 toolTip:"Divide the current resolution by 2" align:#left
	button 'btn_Camera_TV' "TrackView" pos:[80,57] width:72 height:16 toolTip:"Create a new Track View with filters set to show cameras only" align:#left
	label 'lbl1' "Offset" pos:[98,7] width:40 height:14 align:#left	
	GroupBox 'grp_shoot' "Shoot" pos:[4,78] width:152 height:34 align:#left
	GroupBox 'grp_RenderRes' "Render Resolution" pos:[7,216] width:148 height:48 align:#left
	button 'btn_setZ' "Z" pos:[137,325] width:16 height:16 toolTip:"ZDepth" align:#left
	button 'btn_ShootAnim' "A" pos:[137,92] width:16 height:16 toolTip:"Animates selected object from the middle of the View Port to its current position" align:#left
	button 'btn_AimKeys' "AimKeys" pos:[81,195] width:72 height:16 toolTip:"Aim current camera to selected objects and key between them" align:#left
	button 'btn_Spring' "AddSpring" pos:[9,195] width:72 height:16 toolTip:"Add Spring Controller" align:#left
	button 'btn_Shoot_Bullet' "B" pos:[120,92] width:16 height:16 toolTip:"Shoots a bullet from the middle of the current View Port" align:#left
	button 'btn26' "R" pos:[57,179] width:24 height:16 toolTip:"Add Noise Layer to Node (rotation), Careful: !Target gets deactivated!" align:#left

	
--Functions

	fn FnSceneInfo = 
		(
			CamAspect = (renderWidth as float)/renderHeight
			RenderresW = RenderWidth 
			RenderresH = RenderHeight 	
			viewTM = Inverse(getViewTM()) 
			PrTM = viewTM[4]	
			TM1 =ceil PrTM [1]
			TM2 =ceil PrTM [2]	
			TM3 =ceil PrTM [3]	
			edt2.text = ( "Fov: " +  getViewFOV()  as string + ", A " + CamAspect as string +  "\r\n" + "Res: " +  RenderresW as string + "x" + RenderresH as string + "\r\n"+ "Fps: " +  frameRate as string + "\r\n" + "SysUnit: " + units.SystemType + "\r\n"  + "X " + TM1 as string + "  Y "+ TM2 as string + "  Z " +TM3 as string  )	
		)
	fn VrayRenderer =
		(
			rendType = renderers.current 
			names = rendType as string --object name to string
			vrayrender = matchPattern names pattern:"*V_Ray*"
			)
	fn FocusCam  = 
		(
				offset = spn_offset.value 
				cam = $
				viewTM = Inverse(getViewTM()) ---viewport.getTM() 			
				viewPos = viewTM[4] --- or matrix via row:  viewTM.row4
				
				if viewport.getType() == #view_camera do
						(cam = getActiveCamera() --  undefined if the view is not a camera view
						select cam)
						
				if superclassof cam == camera then
					(
					selPos = cam.pos 
							if classof cam == Freecamera do -- freeCamra workaround:free cam dosn't provide a node target for ray method
								( 
								cam.type = #target 
								wasFree = true
							)	
							
								if classof cam == physical do -- physical untargeted workaround:free cam dosn't provide a node target for ray method
								( 
								cam.targeted = on
								wasPhyFree = true
							)	
							
					viewRay = cam as ray
					firstObj = intersectRayScene viewRay
					)
				else
					(
						size = getViewSize() -- point2
						viewRay = mapScreenToWorldRay (size/2) -- ray from middle of the viewport
						firstObj = intersectRayScene viewRay -- array of all objects intersecting
					)
				
				-- check intersections
				if firstObj[1] == undefined then
					(print "no hit")
					else
					(
						surfacePoint = intersectRay firstObj[1][1] viewRay -- surfacepoint of first object intersecting  -- [3][1]
						
						-- get distance for cam or viewport
						if selPos == undefined then
						(
							focusdistval = (distance viewPos (surfacePoint.pos)) --- offset
							)	
						
						else
						(
							focusdistval = (distance selPos (surfacePoint.pos)) --- offset
						)	
						
						withOffset = focusdistval + offset --add offset
						
						--free to objectspace translation needed for this to work:
					
			-- 				if wasFree == true -- freeCamra workaround
			-- 					do (
			-- 					cam.type = #free 
			-- 					)
			-- 				if wasPhyFree == true -- untargeted workaround
			-- 					do (
			-- 					cam.targeted = off
			-- 					)
							
					if classof cam == physical do (
						cam.target_distance = withOffset
						)
					if classof cam == Targetcamera do (
						cam.targetDistance = withOffset
						)
					if classof cam == Freecamera do (
						cam.baseObject.targetDistance = withOffset
						)	
					if classof cam == CoronaCam do (
						cam.targetDistance = withOffset
						)		
					if classof cam == VrayPhysicalcamera do (
						cam.targetDistance = withOffset
						)			
					)
					
				NameObj = firstObj[1] 		
				print ("Object: " +   NameObj[1] as string + " Distance: " + focusdistval as string)
				FnSceneInfo()	
		)
			
	
	on CamTools open do
	(
		FnSceneInfo()
		global SceneText= edt2.text 
		)
	on btn_Focus pressed do
	(
		FocusCam()
		)
	on btn_ShootHelper pressed do
	(
			size = getViewSize() -- point2
			viewRay = mapScreenToWorldRay (size/2) -- ray from middle of the viewport
			firstObj = intersectRayScene viewRay -- array of all objects intersecting
			if firstObj[1] == undefined then
			(print "no hit")
			else
			(
			surfacePoint = intersectRay firstObj[1][1] viewRay -- surfacepoint of first object intersecting  -- [3][1] 
			pos = surfacePoint.pos
			refBox = Point pos:pos isSelected:on Size:5
			focusdistval = (distance viewRay.pos (pos) ) 
			print focusdistval		
				)
			)
	on btn_ShootSpline pressed do
	(
			size = getViewSize() -- point2
			viewRay = mapScreenToWorldRay (size/2) -- ray from middle of the viewport
			firstObj = intersectRayScene viewRay -- array of all objects intersecting
			if firstObj[1] == undefined then
			(print "no hit")
			else
			(
				surfacePoint = intersectRay firstObj[1][1] viewRay -- surfacepoint of first object intersecting  -- [3][1] 
				sp = splineShape()
				addnewSpline sp
				addKnot sp 1 #corner #line viewRay.pos 
				addKnot sp 1 #corner #line surfacePoint.pos
				--close sp 1
				updateShape sp
				--select sp
				pos = surfacePoint.pos
				focusdistval = (distance viewRay.pos (pos) ) 
			print focusdistval
			)
		)
	on btn_SetRenderResA pressed do
	(
			renderSceneDialog.close()
			RenderWidth = 1280
			renderHeight = 720
			completeredraw()
			FnSceneInfo()
		)
	on btn_SetRenderResB pressed do
	(
			renderSceneDialog.close()	
			RenderWidth = 640
			renderHeight = 360
			completeredraw()
			FnSceneInfo()
		)
	on btn_CreateRig pressed do
	(
		VarPoint = Point pos:[0,0,0] size:3.0 name:"Cam_Rig_01"
		VarCamera = physical fov:45 targetDistance:160 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off pos:[0,0,10] rotation:(quat 90 x_axis) isSelected:true name:"Cam_Rig_01_Camera"
		VarCamera.parent = VarPoint
		)
	on btn_SetFoVA pressed do
	(	
			renderSceneDialog.close()
			if viewport.getType() == #view_camera do
					(cam = getActiveCamera()
							cam.specify_fov = off
							cam.focal_length_mm = 24--  undefined if the view is not a camera view
						)
			if $ == undefined and $ != camera do 
				(
					viewport.setFOV 73.74 --24mm
				) 
			if superclassof $ == camera do
						(
							$.focal_length_mm = 24
							)	
			completeredraw()
			FnSceneInfo()
		)
	on btn_SetFoVB pressed do
	(
			renderSceneDialog.close()
			if viewport.getType() == #view_camera do
			(cam = getActiveCamera()
						cam.specify_fov = off
						cam.focal_length_mm = 80--  undefined if the view is not a camera view
				)
			if $ == undefined and $ != camera do 
				(
					viewport.setFOV 25.361 -- 80mm	
				) 
			if superclassof $ == camera do
						(
							$.focal_length_mm = 80
							)	
			completeredraw()
			FnSceneInfo()
		)
	on btn_SetFoVC pressed do
	(
			renderSceneDialog.close()
			if viewport.getType() == #view_camera do
			(cam = getActiveCamera()
						cam.specify_fov = off
						cam.focal_length_mm = 36--  undefined if the view is not a camera view
				)
			if $ == undefined and $ != camera do 
				(
					viewport.setFOV 50.461 --  36mm
				) 
			if superclassof $ == camera do
						(
							$.focal_length_mm = 36
							)	
			completeredraw()
			FnSceneInfo()
		)
	on btn_noiselayer pressed do
	(
			for ObjSelected in selection do(
				
						AnimLayerManager.enableLayers ObjSelected
						AnimLayerManager.addLayer "NoiseP" ObjSelected true
						
						ObjSelected.pos.controller.NoiseP.controller = Noise_position ()
						ObjSelected.pos.controller.NoiseP.controller.fractal = false
						ObjSelected.pos.controller.NoiseP.controller.frequency = 0.1	
						ObjSelected.pos.controller.NoiseP.controller.noise_strength = [1,1,1]
						ObjSelected.pos.controller.NoiseP.controller.seed = random 1 500
		
						)
						AnimLayerManager.showAnimLayersManagerToolbar true	
			)
	on btn_RotLayer pressed do
	(
			s = $
			NewControler = Euler_XYZ()-- create and assign new controller
	-- 			enableORTs NewControler true
	-- 			setAfterORT NewControler #loop 
			s.rotation.controller = NewControler
			kA = addNewKey NewControler 1f
			kB = addNewKey NewControler 101f
	
			s.rotation.controller.Z_Rotation.controller.keys[2].value = 360
			s.rotation.controller.Z_Rotation.controller.keys[2].inTangentType = #linear
			s.rotation.controller.Z_Rotation.controller.keys[1].outTangentType = #linear
			enableORTs	s.rotation.controller.Z_Rotation.controller true
			setAfterORT s.rotation.controller.Z_Rotation.controller #loop
	)
	on btn_AspectB pressed do
	(
			renderSceneDialog.close()
			rwidth = renderWidth
			rheight = renderHeight 
			iAspect = 1.777
			rvalHAspect = rwidth/iAspect
			
			renderHeight = rvalHAspect
			completeredraw()
			FnSceneInfo()
		)
	on btn_AspectC pressed do
	(
			renderSceneDialog.close()
			rwidth = renderWidth
			rheight = renderHeight 
			iAspect = 2.350
			rvalHAspect = rwidth/iAspect
			
			renderHeight = rvalHAspect
			completeredraw()
			FnSceneInfo()
		)
	on btn_AspectA pressed do
	(
			renderSceneDialog.close()
			rwidth = renderWidth
			rheight = renderHeight 
			iAspect = 1.33333
			rvalHAspect = rwidth/iAspect
			
			renderHeight = rvalHAspect
			completeredraw()
			FnSceneInfo()
		)
	on btn_ResMultiplierC pressed do
	(
			renderSceneDialog.close()
			rwmultiplier = 1.5
			rwidth = renderWidth
			rheight = renderHeight 
	
			rvalW = rwidth*rwmultiplier
			rvalH = rheight*rwmultiplier
	
			renderWidth = rvalW
			renderHeight = rvalH
			FnSceneInfo()
		)
	on btn_ResMultiplierD pressed do
	(
			renderSceneDialog.close()
			rwmultiplier = 1.5
			
			rwidth = renderWidth
			rheight = renderHeight 
	
			rvalW = rwidth/rwmultiplier
			rvalH = rheight/rwmultiplier
	
			renderWidth = rvalW
			renderHeight = rvalH
			FnSceneInfo()
		)
	on btn_SceneInfo pressed do
	(
		FnSceneInfo()
		)
	on btn_ResMultiplierA pressed do
	(
			renderSceneDialog.close()
			rwmultiplier = 2
			rwidth = renderWidth
			rheight = renderHeight 
	
			rvalW = rwidth*rwmultiplier
			rvalH = rheight*rwmultiplier
	
			renderWidth = rvalW
			renderHeight = rvalH
			FnSceneInfo()
		)
	on btn_ResMultiplierB pressed do
	(
			renderSceneDialog.close()
			rwmultiplier = 2
			
			rwidth = renderWidth
			rheight = renderHeight 
	
			rvalW = rwidth/rwmultiplier
			rvalH = rheight/rwmultiplier
	
			renderWidth = rvalW
			renderHeight = rvalH
			FnSceneInfo()
		)
	on btn_Camera_TV pressed do
	(
		trackviews.open "Cameras"
		trackView.zoomSelected "Cameras"
		trackviews.setFilter "Cameras" #hideLights #hideGeometry #hideShapes #hideLights #hideHelpers #hideSpacewarps #boneobjects 
		trackviews.clearFilter "Cameras" #visibleObjects #animatedTracks #materialParameters #visibilityTracks #noteTracks #sound #scale #selectedObjects 
		print "New Track View, filters set to show cameras only"
		)
	on btn_setZ pressed do
	(
		renderSceneDialog.close()
		rem = maxOps.GetCurRenderElementMgr()
		VrayRenderer()
		
		if(iskindof renderers.current mental_ray_renderer) then
		(
			rem.AddRenderElement (Z_Depth())
			)	
		if(iskindof renderers.current Default_Scanline_Renderer) then
		(
			rem.AddRenderElement (Z_Depth())
			)			
		if vrayrender == true then
		(
			rem.AddRenderElement (VRayZDepth())
			)	
		if(iskindof renderers.current CoronaRenderer) then
		(
			rem.AddRenderElement (CGeometry_ZDepth())
			)	
		)
	on btn_ShootAnim pressed do
	(
				size = getViewSize() -- point2
				viewRay = mapScreenToWorldRay (size/2) -- ray from middle of the viewport
				firstObj = intersectRayScene viewRay -- array of all objects intersecting
				if firstObj[1] == undefined then
				(print "no hit")
				else
				(
				surfacePoint = intersectRay firstObj[1][1] viewRay -- surfacepoint of first object intersecting  -- [3][1] 
				current_Time = sliderTime
					
				if $selection[1] == undefined then
					(
						refBox = Box lengthsegs:1 widthsegs:3 heightsegs:3 length:0.36 width:0.8 height:1.8 mapcoords:on pos:[0.118158,-0.0899162,0] isSelected:on name: "tmp_refbox"
						addmodifier refBox  (Edit_Poly())
		-- 					refBox.modifiers[#Edit_Poly].Select #Face #{5}
		-- 					refBox.modifiers[#EditPoly].extrudeFaceHeight = 0.40
						refBox.pos = surfacePoint.pos	
					)	
					else 
					(
						with animate on
							(
							at time current_Time  $.pos = viewRay.pos 
							at time (current_Time+50)  $.pos = surfacePoint.pos	
						)
					)
				)
		)
	on btn_AimKeys pressed do
	(
		if viewport.getType() == #view_camera then
					(
	
						cam = getActiveCamera()
						
								if classof cam == Freecamera do ( -- freeCamra workaround:free cam dosn't provide a node target for ray method
								cam.type = #target 
								wasFree = true
								)			
								if classof cam == physical do ( -- physical untargeted workaround:free cam dosn't provide a node target for ray method
								cam.targeted = on
								wasPhyFree = true
								)	
						
						target = cam.target
	
						objSelection = getCurrentSelection()
						positions = for i in objSelection collect (i.pos) --Array of seleted obj pos
						--print positions
						StartT =  CurrentTime
	
						with animate on
							(
								for p in positions do (
									
									KeyB = 10	
									
									if p.count > 1 do(
										StartT = StartT+20
									)
									
									at time StartT target.pos =  p
									at time (StartT + KeyB) target.pos =  p	
									--at time StartT cam.rotation = cam.rotation
									
									Print StartT		
								)
							)            
						select target
							
	-- 					if wasFree == true -- freeCamra workaround
	-- 					do (
	-- 					cam.type = #free 
	-- 					)
	-- 					if wasPhyFree == true -- untargeted workaround
	-- 					do (
	-- 					cam.targeted = off
	-- 					)						
					)			
		else (Print "Switch to camera view!")
	)
	on btn_Spring pressed do
	(
			for i in selection do(
			i.pos.controller = SpringPositionController ()
				)
			max motion mode
		)
	on btn_Shoot_Bullet pressed do
	(
			--- Shoot builet
					size = getViewSize() -- point2
					viewRay = mapScreenToWorldRay (size/2) -- ray from middle of the viewport
					firstObj = intersectRayScene viewRay -- array of all objects intersecting
					if firstObj[1] == undefined then
					(print "no hit")
					else
					(
							surfacePoint = intersectRay firstObj[1][1] viewRay -- surfacepoint of first object intersecting  -- [3][1] 
							sp = splineShape name:"spline_ray"
							addnewSpline sp
							addKnot sp 1 #corner #line viewRay.pos 
							addKnot sp 1 #corner #line surfacePoint.pos
							--close sp 1
							updateShape sp
							--select sp
							pos = surfacePoint.pos
							focusdistval = (distance viewRay.pos (pos) ) 
						print focusdistval
	
						pathspline=sp
						bulletObj=pyramid width:1 depth:1 height: 2 name:"Bullet" wireColor:[99,22,186]
						bulletObj.pos.controller = path follow:true
						PosCont=bulletObj.pos.controller -- grab the path controller
						PosCont.path=pathspline -- set path to shape node
						PosCont.axis=2 -- local Z
	
						animate on
						(
						startT = currenttime
						intervalT = 60
						at time startT PosCont.percent=0 
						at time (startT+intervalT) PosCont.percent=100 
						)
						
					)
		)
	on btn26 pressed do
	(
			for ObjSelected in selection do(
						
						if classof ObjSelected == Freecamera do ( -- freeCamra workaround:free cam dosn't provide a node target for ray method
								ObjSelected.type = #untarget 
								)		
								
						if classof ObjSelected == physical do ( -- physical untargeted workaround
								ObjSelected.targeted = off
								)	
			
						AnimLayerManager.enableLayers ObjSelected
						AnimLayerManager.addLayer "NoiseR" ObjSelected true
						
						ObjSelected.rotation.controller.NoiseR.controller = Noise_rotation ()
						ObjSelected.rotation.controller.NoiseR.controller.fractal = false
						ObjSelected.rotation.controller.NoiseR.controller.frequency = 0.1
						ObjSelected.rotation.controller.NoiseR.controller.noise_strength = [0.1,0.1,0.1]
						ObjSelected.rotation.controller.NoiseR.controller.seed = random 1 500
		
						)
						AnimLayerManager.showAnimLayersManagerToolbar true	
			)
)


createdialog CamTools
SetDialogPos CamTools [1200,150]


