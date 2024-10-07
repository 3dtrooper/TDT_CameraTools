-- Trooper Cam_Tools
-- V 0.5 release
-- V 0.6 UI update
-- V 0.7 fixes
-- V 0.8 the key range is shown if the camera is animated, bug fixes (camera focus), octane support
-- V 0.9 new sorting function to make the focus more reliable, bug fixes

macroScript macroScript TrooperCamTools
category:"Trooper"
tooltip:"Camera Tools"
buttontext:"Camera Tools"
(

	try(cui.UnRegisterDialogBar CamTools)catch()   
	if CamTools != undefined then (destroyDialog CamTools)      
	
	Cams = #()
	viewTM = Inverse(getViewTM())
	
	fn updateCams =(
		for i in cameras do(
			if i.isAnimated == true then
			(
				range = getTimeRange i.controller #allKeys #children
				startFrame = range.start as string
				startFrame.count
				startFrameString = substring startFrame 1 (startFrame.count-1)
				endFrame = range.end as string
				endFrame.count
				endFrameString = substring endFrame 1 (endFrame.count-1)
				camNameAndRange = ( "[" + (startFrameString) + "-" + (endFrameString) + "]")
				)	
			else (
				camNameAndRange = ""
				)		
			if i.isTarget == false then (
			append Cams (i.name + camNameAndRange)
			sort Cams
			)
			else()
		)
	)
	
	global CamToolsn
	global SceneCams
	global viewMatrix
	global loc
	global savedViewMatrixA
	global savedViewMatrixB
	global savedViewMatrixC
	
	fn CamAdded = (
			Cams = #()
			updateCams()
			CamTools.SceneCams.items = Cams
		)
		
	callbacks.addScript #sceneNodeAdded CamAdded id:#CamNodeCallback
	callbacks.addScript #nodeCloned CamAdded id:#CamNodeCallback
	callbacks.addScript #nodePostDelete CamAdded id:#CamNodeCallback
	callbacks.addScript #nodeRenamed CamAdded id:#CamNodeCallback	
			
	rollout CamTools "Camera Tools" width:160 height:775
	(
		button 'btnFloat' "F" pos:[124,8] width:32 height:14 toolTip:"Float Dialog" align:#left
		button 'btnDockLeft' "<" pos:[124,23] width:16 height:14 toolTip:"Dock Left" align:#left
		button 'btnDockRight' ">" pos:[140,23] width:16 height:14 toolTip:"Dock Right" align:#left
		button 'btn_Focus' "Focus" pos:[8,8] width:50 height:29 toolTip:"Focuses current or the selected camera" align:#left
		label 'lbl1' "Offset" pos:[66,6] width:40 height:14 align:#left		
		spinner 'spn_offset' "" pos:[64,18] width:48 height:16 range:[-5000,5000,0] align:#left
		button 'btn_getCamTarget' "Get Target" pos:[8,40] width:72 height:16 toolTip:"Toggle between camera and target" align:#left
		GroupBox 'grp_CreateObjs' "Create Cameras" pos:[6,60] width:152 height:34 align:#left
		button 'btn_CreateCam' "Create Camera From View" pos:[8,72] width:72 height:16 toolTip:"Create Camera From View" align:#left
		button 'btn_CreateRig' "Create Rig" pos:[80,72] width:72 height:16 toolTip:"Create a simple camera rig. Focused on current selection,and linked to selection" align:#left
		GroupBox 'grp_shoot' "Shoot" pos:[6,91] width:152 height:34 align:#left
		button 'btn_ShootHelper' "ShootHelper" pos:[8,105] width:72 height:16 toolTip:"Shoots a point helper from the middle of the current View Port" align:#left
		button 'btn_ShootSpline' "ShootS" pos:[80,105] width:40 height:16 toolTip:"Shoots a spline from the middle of the current View Port" align:#left
		button 'btn_SetRenderResA' "1920x1080" pos:[9,294] width:64 height:16 toolTip:"Set Render Resolution to 1920x1080: 16:9 (HD)" align:#left
		button 'btn_SetRenderResB' "4096x2214" pos:[9,310] width:64 height:16 toolTip:"Set Render Resolution to 4096x2214: 1.85:1 (cine)" align:#left
		GroupBox 'grp_SetCamTo' "Set Focal Length/Aspect" pos:[6,127] width:152 height:95 align:#left
		button 'btn_SetFoVA' "21mm" pos:[9,143] width:48 height:16 toolTip:"Set Focal Length" align:#left
		button 'btn_SetFoVB' "24mm" pos:[57,143] width:48 height:16 toolTip:"Set Focal Length" align:#left
		button 'btn_SetFoVC' "35mm" pos:[105,143] width:48 height:16 toolTip:"Set Focal Length" align:#left
		button 'btn_SetFoVE' "50mm" pos:[9,161] width:48 height:16 toolTip:"Set Focal Length" align:#left
		button 'btn_SetFoVD' "85mm" pos:[57,161] width:48 height:16 toolTip:"Set Focal Length" align:#left
		button 'btn_SetFoVF' "105mm" pos:[105,161] width:48 height:16 toolTip:"Set Focal Length" align:#left
		GroupBox 'grp3' "Animation" pos:[6,225] width:152 height:55 align:#left
		button 'btn_noiselayer' "Noise P" pos:[9,240] width:48 height:16 toolTip:"Add Noise Layer to Node (position)" align:#left
		button 'btn_RotLayer' "Rotation" pos:[81,240] width:72 height:16 toolTip:"Add Rotation Key Frames to Node" align:#left
		button 'btn_AspectA' "16:9" pos:[9,187] width:48 height:16 toolTip:"Set Aspect to 16:9 (HDTV)" align:#left
		button 'btn_AspectB' "1.85:1" pos:[57,187] width:48 height:16 toolTip:"Set Aspect to 18.5:1 (Cine)" align:#left
		button 'btn_AspectC' "2.35:1" pos:[105,187] width:48 height:16 toolTip:"Set Aspect to 2,35:1 (35mm Anamorphic)" align:#left
		button 'btn_AspectD' ".675:1" pos:[57,204] width:48 height:16 toolTip:"Set Aspect to 27x40 (US Poster)" align:#left
		button 'btn_AspectE' "1:1" pos:[9,204] width:48 height:16 toolTip:"Set Aspect to 1:1" align:#left
		button 'btn_printSize' "Print" pos:[105,204] width:48 height:16 toolTip:"Open Print Size Wizard" align:#left
		button 'btn_ResMultiplierC' "x1.5" pos:[81,310] width:32 height:16 toolTip:"Multiply the current resolution by 1.5" align:#left
		button 'btn_ResMultiplierD' "/1.5" pos:[121,310] width:32 height:16 toolTip:"Divide the current resolution by 1.5" align:#left
		edittext 'edtInfoBox' "" pos:[5,334] width:148 height:44 readOnly:true align:#left toolTip:"Scene Info: Fov, Aspect, Render Resolution, Fps, Current Viewport Position"
		button 'btn_ResMultiplierA' "x2" pos:[81,294] width:32 height:16 toolTip:"Multiply the current resolution by 2" align:#left
		button 'btn_ResMultiplierB' "/2" pos:[121,294] width:32 height:16 toolTip:"Divide the current resolution by 2" align:#left
		GroupBox 'grp_RenderRes' "Render Resolution" pos:[6,280] width:152 height:48 align:#left
		button 'btn_ShootAnim' "A" pos:[137,105] width:16 height:16 toolTip:"Animates selected object from the middle of the View Port to its current position" align:#left
		button 'btn_AimKeys' "AimKeys" pos:[81,256] width:72 height:16 toolTip:"Aim current camera to selected objects and key between them" align:#left
		button 'btn_Spring' "AddSpring" pos:[9,256] width:72 height:16 toolTip:"Add Spring Controller" align:#left
		button 'btn_Shoot_Bullet' "B" pos:[120,105] width:16 height:16 toolTip:"Shoots a bullet from the middle of the current View Port" align:#left
		button 'btn_NoiseLayerB' "R" pos:[57,240] width:24 height:16 toolTip:"Add Noise Layer to Node (rotation), Careful: !Targets get deactivated!" align:#left
		GroupBox 'grp4' "Time Slider" pos:[6,384] width:152 height:55 align:#left
		button 'btn_GetRangeFromSelected' "Get Key Range" pos:[8,396] width:78 height:16 toolTip:"Get Time Slider Range from selected object's keys" align:#left
		button 'btn_ChangeRangeA' "0-500" pos:[86,396] width:32 height:16 toolTip:"Set Time Slider Range 0-500" align:#left
		button 'btn_ChangeRangeB' "0-5000" pos:[120,396] width:36 height:16 toolTip:"Set Time Slider Range 0-5000" align:#left
		button 'btn_SceneInfo' "Refresh" pos:[58,418] width:44 height:16 toolTip:"Refresh" align:#left
		button 'btn_Camera_TV' "TrackView" pos:[105,418] width:52 height:16 toolTip:"Create a new Track View with filters set to show cameras only" align:#left
		label 'CameraLabel' "Cameras:" pos:[9,421] width:45 height:13 align:#left 
		listbox 'SceneCams' "" pos:[9,438] width:144 height:25 align:#left  toolTip:"Single Click to select, Double Click to jump to cam, Right Click to go back to former view"
	
	
		fn setViewMatrix loc = (
			viewMatrix = inverse (viewport.getTM())
			case loc of (
				1: savedViewMatrixA = viewMatrix
				2: savedViewMatrixB = viewMatrix
				3: savedViewMatrixC = viewMatrix
			)
		)
		fn getViewMatrix loc = (
			case loc of (
				1: viewMatrix = savedViewMatrixA
				2: viewMatrix = savedViewMatrixB
				3: viewMatrix = savedViewMatrixC
			)
			if viewMatrix != undefined do
			(
				viewport.SetTM (inverse viewMatrix)
			)
		)
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
				edtInfoBox.text = ( "Fov: " + getViewFOV() as string + "   Asp: " + CamAspect as string + "\r\n" + "Res: " + RenderresW as string + "x" + RenderresH as string + "  Fps: " + frameRate as string + "\r\n" +  "X " + TM1 as string + "  Y "+ TM2 as string + "  Z " +TM3 as string  )	
			) --"SysUnit: " + units.SystemType + "\r\n" 
		fn VrayRenderer =
			(
				rendType = renderers.current 
				names = rendType as string
				vrayrender = matchPattern names pattern:"*V_Ray*"
				)
		fn sortObjectsByDistance baseObject objectArray =
		(
			local distanceArray = #()
			local sortedObjectArray = objectArray
	
			for obj in objectArray do
			(
				dist = distance baseObject obj
				append distanceArray dist
			)
			for i = 1 to distanceArray.count-1 do --bubble sort
			(
				for j = 1 to distanceArray.count-i do
				(
					if distanceArray[j] > distanceArray[j+1] then
					(
						tempDist = distanceArray[j]
						distanceArray[j] = distanceArray[j+1]
						distanceArray[j+1] = tempDist
						
						tempObj = sortedObjectArray[j]
						sortedObjectArray[j] = sortedObjectArray[j+1]
						sortedObjectArray[j+1] = tempObj
					)
				)
			)
			return sortedObjectArray
		)
		fn FocusCam  = 
			(
				offset = spn_offset.value 
				cam = selection[1]
				viewTM = Inverse(getViewTM())			
				viewPos = viewTM[4] --- or matrix via row:  viewTM.row4
				wasFree = false	
				wasPhyFree = false
				if viewport.getType() == #view_camera do
						(
							cam = getActiveCamera()
							)	
				with undo on (	
				if superclassof cam == camera do
					(
					selPos = cam.pos 
							if classof cam == Freecamera or cam == Targetcamera do
								( 
								if cam.type != #target do
									(
									cam.type = #target 
									wasFree = true
									)
								)	
							if classof cam == Physical or classof cam == VRayPhysicalCamera or classof cam == CoronaCam or classof cam == FStormCamera or classof cam == Universal_Camera do
								( 	
									if cam.targeted == off do
									(
										cam.targeted = on
										wasPhyFree = true
									)
							)
		
					viewRay = cam as ray
					hitObjs = intersectRayScene viewRay
							
					firstValues = #() 
					for j = 1 to hitObjs.count do --get nodes
						(
							append firstValues hitObjs[j][1]
						)
						
					sortedObjects = sortObjectsByDistance cam firstValues --distance		
							
					if sortedObjects[1] == undefined then
						(print "no hit")
						else
						(
						surfacePoint = intersectRay sortedObjects[1] viewRay -- sortedObjects[1][1]
						if selPos == undefined then
						(
							focusdistval = (distance viewPos (surfacePoint.pos)) 
							)	
						else
						(
							focusdistval = (distance selPos (surfacePoint.pos)) 
						)
					withOffset = focusdistval + offset
	
					if classof cam == Physical do (										
						if cam.specify_focus == 1 then	(
							cam.focus_distance = withOffset
							)
							else cam.target_distance = withOffset
						if wasPhyFree == true
						do (
						cam.targeted = off
						)		
						)
					if classof cam == Targetcamera do (
						if cam.mpassEffect.useTargetDistance == off then (
							cam.mpassEffect.focalDepth = withOffset
						)
						else cam.targetDistance = withOffset
						if wasFree == true
						do (
						cam.type = #free 
						)	
						)
					if classof cam == Freecamera do (
						cam.baseObject.targetDistance = withOffset
						)	
					if classof cam == CoronaCam do (
						if cam.overrideFocusDistance == on then (
							cam.dofOverrideFocusDistance = withOffset
							)
						else cam.baseObject.targetDistance = withOffset
						)		
					if classof cam == VRayPhysicalCamera do (
						if cam.specify_focus == on and cam.targeted == off then (
							cam.focus_distance = withOffset
							)
						else if cam.specify_focus == off and cam.targeted == on then  (
							cam.targeted = off
							cam.target_distance = withOffset
							)
						else if cam.specify_focus == on and cam.targeted == on then (
	-- 						cam.targeted = on
							cam.focus_distance = withOffset
							)
						else if cam.targeted == off then (
							cam.targeted = on
							cam.specify_focus = on
							cam.focus_distance = withOffset
							)	
						if wasPhyFree == true
						do (
						cam.targeted = off
						)		
						)			
					if classof cam == FStormCamera do (
						if cam.dof_targeted == 0 then (
							cam.dof_focaldist = withOffset
							)
						else (
							cam.targeted = off
							cam.targ_dist = withOffset
							cam.targeted = on
							)
						)
					if classof cam == Universal_Camera or classof cam == cameracamera do (
						if cam.target_mode == off then (
							cam.focalDepth = withOffset
							)
						else (
							cam.target_mode = off
							cam.target_distance = withOffset
							cam.target_mode = on
							)
						)	
					)
				)
			completeredraw()		
			FnSceneInfo()					
			)
		)
		fn setFov fovpreset fovpresetmm = (
				renderSceneDialog.close()
				if viewport.getType() == #view_camera do
						(cam = getActiveCamera()
							if classof cam == TargetCamera or classof cam == Freecamera or classof cam == Physical do
								(
								cam.fov= fovpresetmm 
								)
							if classof cam == VRayPhysicalCamera or classof cam == CoronaCam do
							(
								cam.focal_length = fovpresetmm
								)	
							)
				if $ != camera or $ == undefined do 
					(
						viewport.setFOV fovpreset
					) 
				if classof $ == VRayPhysicalCamera or classof $ == CoronaCam do
				(
					$.focal_length = fovpresetmm
					)					
				if classof $ == Targetcamera or classof $ == Freecamera do
				(
					$.fov = fovpreset
					)	
				if classof $ == Physical do
				(
					$.focal_length_mm = fovpresetmm
					)		
				if classof $ == FStormCamera  do
				(
					$.lens = fovpresetmm
					)			
				completeredraw()
				FnSceneInfo()
			)
		fn setAspect aspectRatio = (
			renderSceneDialog.close()
			rwidth = renderWidth
			rheight = renderHeight 
			iAspect = aspectRatio
			rvalHAspect = rwidth/iAspect
			renderHeight = rvalHAspect
			completeredraw()
			FnSceneInfo()
		)
	
		fn getLargestDimension obj =
		(
			obj = selection[1]
			bbox = obj.boundingBox
			size = bbox.max - bbox.min
			largest = #(size.x, size.y, size.z)
			sorted = sort largest
			returnvalue = sorted[3]
		)
		
		
		---------------------------------------------------- Buttons-----------------------------------------
		
		on CamTools open do
		(
			updateCams()
			FnSceneInfo()
			global SceneText= edtInfoBox.text 
			SceneCams.items = Cams
			)
		on CamTools close do
		(
			callbacks.removeScripts id:#CamNodeCallback
			callbacks.show id:#CamNodeCallback
			)
		on CamTools resized val do
		(
			SceneCams.height = val.y-444
		)
		on btnFloat pressed do
		(
				try(cui.UnRegisterDialogBar CamTools) catch()
				createDialog CamTools
				SetDialogSize CamTools [160,775]
			)
		on btnDockLeft pressed do
		(
				try(cui.UnRegisterDialogBar CamTools) catch()
				createDialog CamTools
				cui.RegisterDialogBar CamTools
				cui.DockDialogBar CamTools #cui_dock_left
			)
		on btnDockRight pressed do
		(
				try(cui.UnRegisterDialogBar CamTools) catch()
				createDialog CamTools 
				cui.RegisterDialogBar CamTools
				cui.DockDialogBar CamTools #cui_dock_right
			)
		on btn_Focus pressed do
		(
			FocusCam()
			)
		
		on btn_ShootHelper pressed do
		(
				size = getViewSize()
				viewRay = mapScreenToWorldRay (size/2)
				firstObj = intersectRayScene viewRay 
				if firstObj[1] == undefined then
				(print "no hit")
				else
				(
				surfacePoint = intersectRay firstObj[1][1] viewRay
				pos = surfacePoint.pos
				refBox = Point pos:pos isSelected:on Size:5
				focusdistval = (distance viewRay.pos (pos) ) 
				print focusdistval		
				)
			)
		on btn_ShootSpline pressed do
		(
			size = getViewSize()
			viewRay = mapScreenToWorldRay (size/2)
			firstObj = intersectRayScene viewRay 
			if firstObj[1] == undefined then
			(print "no hit")
			else
			(
				surfacePoint = intersectRay firstObj[1][1] viewRay
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
				RenderWidth = 1920
				renderHeight = 1080
				completeredraw()
				FnSceneInfo()
			)
		on btn_SetRenderResB pressed do
		(
				renderSceneDialog.close()	
				RenderWidth = 4096
				renderHeight = 2214
				completeredraw()
				FnSceneInfo()
			)
		on btn_CreateCam pressed do
		(
			local cam
			viewfov = getVIewFOV()
			viewMatrixB =  Inverse(viewport.getTM())	
			rendType = renderers.current 
			names = rendType as string
		
			if matchPattern names pattern:"*V_Ray*" do
			(
				cam = VRayPhysicalCamera targeted:false
				)
			if matchPattern names pattern:"*Corona*" do
			(
				cam = CoronaCam targeted:false
				)	
			if matchPattern names pattern:"*Arnold*" do
			(
				cam = Physical()
				)
			if matchPattern names pattern:"*Scanline*" do	
			(
				cam = Freecamera()
				)	
		
			if matchPattern names pattern:"*FStorm*" do	
			(
				cam = FStormCamera()
				)		
			if matchPattern names pattern:"*Octane*" do	
			(
				cam = Universal_Camera()
				)		
			if viewport.Gettype() == #view_persp_user do
				(
					if classof cam == CoronaCam do  
						(
							cam.focalLength = viewfov
							)		
					if classof cam == Targetcamera or classof cam == Freecamera or classof cam == Physical or classof cam == VRayPhysicalCamera  or classof cam == FStormCamera or classof cam == Universal_Camera do
						(
							cam.fov = viewfov
							)			
					cam.Transform= viewMatrixB 
					viewport.setcamera cam
					select cam
				)
			)
		on btn_CreateRig pressed do
		(
			undo on (
			dist = 10	
			rendType = renderers.current 
			names = rendType as string
			if selection != undefined do (	
				targetObj = selection[1]	
				objPos = selection[1].pos
				targetObjDimension = getLargestDimension targetObj
				dist = 3*targetObjDimension
				)
			VarPoint = Point pos:[0,0,0] size:3.0 name: (targetObj.name as string + "_Cam_Rig")
	
			if matchPattern names pattern:"*V_Ray*" do
			(
				VarCamera = VRayPhysicalCamera targeted:false rotation:(quat 90 x_axis)
				)
					if matchPattern names pattern:"*Corona*" do
			(
				VarCamera = CoronaCam targeted:false rotation:(quat 90 x_axis) isSelected:true
				)	
			if matchPattern names pattern:"*Arnold*" do
			(
				VarCamera = physical fov:65 targetDistance:10 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off pos:[0,0,10] rotation:(quat 90 x_axis) isSelected:true
				)	
			VarCamera.parent = VarPoint 
			VarCamera.name = (targetObj.name as string + "_PhysCam")
				if selection[1]	!= undefined then
					(
						VarPoint.pos = objPos
						VarPoint.parent = targetObj
						VarCamera.pos = (VarCamera.pos + [0,-dist,0])
						print objPos
					)
				)
			)
		on btn_SetFoVA pressed do
		(	
			fovpresetmm = 21
			fovpreset = 90.772 --21mm
			setFov fovpreset fovpresetmm
			)
		on btn_SetFoVB pressed do
		(
			fovpresetmm = 24
			fovpreset = 83.138 --24mm
			setFov fovpreset fovpresetmm
			)
		on btn_SetFoVC pressed do
		(
			fovpresetmm = 35
			fovpreset = 62.611 --35mm	
			setFov fovpreset fovpresetmm
			)
		on btn_SetFoVE pressed do
		(
			fovpresetmm = 50
			fovpreset = 27.215 -- 50mm	
			setFov fovpreset fovpresetmm
			)
		on btn_SetFoVD pressed do
		(
			fovpresetmm = 85
			fovpreset = 9.784 -- 85mm	
			setFov fovpreset fovpresetmm
			)
		on btn_SetFoVF pressed do
		(
			fovpresetmm = 105
			fovpreset = 4.926 -- 105mm	
			setFov fovpreset fovpresetmm
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
		on btn_NoiseLayerB pressed do
		(
			for ObjSelected in selection do(
				if classof ObjSelected == Targetcamera  do (
						ObjSelected.type = #free
					)		
				if classof ObjSelected == physical or classof ObjSelected == VRayPhysicalCamera or classof ObjSelected == CoronaCam do (
						ObjSelected.targeted = off
					)
				AnimLayerManager.enableLayers ObjSelected
				AnimLayerManager.addLayer "NoiseR" ObjSelected true
				ObjSelected.rotation.controller.NoiseR.controller = Noise_rotation()
				ObjSelected.rotation.controller.NoiseR.controller.fractal = false
				ObjSelected.rotation.controller.NoiseR.controller.frequency = 0.1
				ObjSelected.rotation.controller.NoiseR.controller.noise_strength = [0.1,0.1,0.1]
				ObjSelected.rotation.controller.NoiseR.controller.seed = random 1 500
				)
				AnimLayerManager.showAnimLayersManagerToolbar true	
			)
		on btn_RotLayer pressed do
		(
			for ObjSelected in selection do(
				
				AnimLayerManager.enableLayers ObjSelected
				AnimLayerManager.addLayer "Rotate_360" ObjSelected true
				NewControler = Euler_XYZ()-- create and assign new controller
				ObjSelected.rotation.controller.Rotate_360.controller = NewControler
				kA = addNewKey NewControler 1f
				kB = addNewKey NewControler 101f
				ObjSelected.rotation.controller.Rotate_360.Z_Rotation.controller.keys[1].value = 1
				ObjSelected.rotation.controller.Rotate_360.Z_Rotation.controller.keys[2].value = 360
				ObjSelected.rotation.controller.Rotate_360.Z_Rotation.controller.keys[2].inTangentType = #linear
				ObjSelected.rotation.controller.Rotate_360.Z_Rotation.controller.keys[1].outTangentType = #linear
				enableORTs	ObjSelected.rotation.controller.Rotate_360.Z_Rotation.controller true
				setAfterORT ObjSelected.rotation.controller.Rotate_360.Z_Rotation.controller #loop
			)
			AnimLayerManager.showAnimLayersManagerToolbar true	
		)
		on btn_getCamTarget pressed do
		(
			if classOf selection[1] == Targetobject then
			(
				parentC = selection[1].lookAt  -- .isTarget  classof $
				select parentC
			) 
			else if viewport.getType() == #view_camera then
				(	
					cam = getActiveCamera()
					targetA = cam.target
					if targetA != undifined do select targetA
					)
			else if superClassOf selection[1] == camera then
				(
					targetA = selection[1].target
					if targetA != undifined do select targetA
				) 
		)
		on btn_AspectA pressed do
		(
			ratio = 1.777 
			setAspect ratio
			)
		on btn_AspectB pressed do
		(
			ratio = 1.85
			setAspect ratio
			)
		on btn_AspectC pressed do
		(
			ratio = 2.350
			setAspect ratio
			)
		on btn_AspectD pressed do
		(
			ratio = 0.675
			setAspect ratio
			)
		on btn_AspectE pressed do
		(
			ratio = 1
			setAspect ratio
			)
		on btn_printSize pressed do (
			macros.run "Render" "RenderToPrint"
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
			Cams = #()
			updateCams()
			SceneCams.items = Cams
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
		on btn_ShootAnim pressed do
		(
				size = getViewSize() -- point2
				viewRay = mapScreenToWorldRay (size/2)
				firstObj = intersectRayScene viewRay
				if firstObj[1] == undefined then
				(print "no hit")
				else
				(
				surfacePoint = intersectRay firstObj[1][1] viewRay
				current_Time = sliderTime					
				if $selection[1] == undefined then
					( 
					refBox = Box lengthsegs:1 widthsegs:3 heightsegs:3 length:0.36 width:0.8 height:1.8 mapcoords:on pos:[0.118158,-0.0899162,0] isSelected:on name: "tmp_refbox"
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
					if cam.target != undefined do (
						AnimLayerManager.enableLayers cam.target
						AnimLayerManager.addLayer "Aim Keys" cam.target true
							if classof cam == Freecamera do (
								cam.type = #target 
								wasFree = true
								)			
							if classof cam == physical do (
								cam.targeted = on
								wasPhyFree = true
								)							
						target = cam.target
						objSelection = getCurrentSelection()
						positions = for i in objSelection collect (i.pos)
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
					)					
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
				size = getViewSize() -- point2
				viewRay = mapScreenToWorldRay (size/2)
				firstObj = intersectRayScene viewRay
				if firstObj[1] == undefined then
				(print "no hit")
				else
				(
						surfacePoint = intersectRay firstObj[1][1] viewRay
						sp = splineShape name:"spline_ray_"
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
	
		on btn_GetRangeFromSelected pressed do
		(
			if $ == undefined then
			(
				print "no slection"
				)
			else
			(
			if $.isAnimated == true do 
			(
				animationRange = getTimeRange selection[1].controller #allKeys #children
				)	
			)
		)
		on btn_ChangeRangeA pressed do
		(
			animationRange = interval 0 500
			)
		on btn_ChangeRangeB pressed do
		(
			animationRange = interval 0 5000
			)
		on btn_Camera_TV pressed do
		(
			trackviews.open "Cameras"
			trackView.zoomSelected "Cameras"
			trackviews.setFilter "Cameras" #hideLights #hideGeometry #hideShapes #hideLights #hideHelpers #hideSpacewarps #boneobjects 
			trackviews.clearFilter "Cameras" #visibleObjects #animatedTracks #materialParameters #visibilityTracks #noteTracks #sound #scale #selectedObjects 
			print "New Track View, filters set to show cameras only"
			)
		on SceneCams selected nameIndex do
		(
			camName = filterString SceneCams.items[nameIndex] "[]"
					select (getNodeByName camName[1])
			)
		on SceneCams doubleClicked nameIndex do
		(
					if viewport.getType() == #view_persp_user do 
						(
						global viewFov = getViewFOV()
						global viewTM = getViewTM()
					) 				
					viewPos = viewTM[4]	
					SceneCams.selection = nameIndex
					camName = filterString SceneCams.items[nameIndex] "[]"
					viewport.setCamera (getNodeByName camName[1]) 
			)
		on SceneCams rightClick nameIndex do
		(
				viewport.setType #view_persp_user
				viewport.setTM viewTM
				viewport.SetFOV viewFov
			)
	)
	createDialog CamTools style:#(#style_resizing,#style_titleba,#style_toolwindow,#style_sysmenu)lockHeight:false lockWidth:true
	SetDialogPos CamTools [1600,150]

)
