import qualified Data.Map as Map
import System.IO
import System.Exit

import XMonad
import XMonad.Actions.CycleWS (moveTo, Direction1D(Next), nextWS,
  WSType(NonEmptyWS), Direction1D(Prev), prevWS, shiftToNext, shiftToPrev)
import XMonad.Actions.SpawnOn
import XMonad.Actions.Volume (lowerVolume, raiseVolume, toggleMute)
import XMonad.Hooks.DynamicLog (defaultPP, dynamicLogWithPP, ppCurrent,
  ppHidden, ppHiddenNoWindows, ppLayout, ppOutput, ppSep, ppTitle, ppUrgent,
  ppVisible, ppWsSep, shorten, wrap, xmobarColor, xmobarPP, xmobarStrip)
import XMonad.Hooks.ICCCMFocus (takeTopFocus)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.MultiToggle ((??), EOT (..), mkToggle, Toggle (..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL))
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import qualified XMonad.StackSet as W
import XMonad.Util.Run (safeSpawn, unsafeSpawn, spawnPipe)


myBorderWidth = 1
myFocusedBorderColor = "#cccc88"
myNormalBorderColor  = "#666666"
myModMask = mod4Mask -- super key
myStartupHook = setWMName "LG3D" -- Deal with Java apps.
myTerminal = "urxvt"

------------------------------------------------------------------------
-- key bindings

myKeys conf@(XConfig {XMonad.modMask = modMask}) = Map.fromList $ [

    -- Call external programs.
    ((modMask              , xK_e     ), safeSpawn "/usr/bin/pcmanfm" []),  -- Launch file manager.
    ((modMask .|. shiftMask, xK_l     ), unsafeSpawn "zenity --question --text 'Bildschirm sperren?' && slock"),  -- Lock screen after asking.
    ((modMask              , xK_p     ), spawnHere "exe=`dmenu_path | dmenu -b -nb \"#000000\" -nf \"#dddddd\" -sb \"#ff8800\" -sf \"#000000\"` && eval \"exec $exe\""),  -- Launch dmenu.
    ((modMask              , xK_w     ), unsafeSpawn "~/bin/set_random_wallpaper.sh"),  -- Set random wallpaper.
    ((modMask              , xK_Return), spawn $ XMonad.terminal conf),  -- Launch terminal.

    -- Control layout.
    ((modMask              , xK_f     ), sendMessage (Toggle NBFULL) >> sendMessage ToggleStruts),  -- Toggle fullscreen mode.
    ((modMask              , xK_h     ), sendMessage Shrink),  -- Shrink master area.
    ((modMask              , xK_l     ), sendMessage Expand),  -- Expand master area.
    ((modMask              , xK_space ), sendMessage NextLayout),  -- Rotate through available algorithms.
    ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf),  -- Reset layouts on the current workspace.
    ((modMask              , xK_comma ), sendMessage (IncMasterN 1)),  -- Increment number of windows in master area.
    ((modMask              , xK_period), sendMessage (IncMasterN (-1))),  -- Deincrement number of windows in master area.

    -- Control windows.
    ((modMask .|. shiftMask, xK_c     ), kill),  -- Close focused window.
    ((modMask              , xK_n     ), refresh),  -- Resize viewed windows to the correct size
    ((modMask              , xK_Tab   ), windows W.focusDown),  -- Focus next window.
    ((modMask              , xK_j     ), windows W.focusDown),  -- Focus next window.
    ((modMask              , xK_k     ), windows W.focusUp  ),  -- Focus previous window.
    ((modMask              , xK_m     ), windows W.focusMaster  ),  -- Focus master window.
    ((modMask              , xK_t     ), withFocused $ windows . W.sink),  -- Push window back into tiling.
    ((modMask .|. shiftMask, xK_Return), windows W.swapMaster),  -- Swap focused window and master window.
    ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  ),  -- Swap focused window with next window.
    ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    ),  -- Swap focused window with previous window.
    --((modMask .|. shiftMask, xK_h     ), sendMessage MirrorShrink),  -- Shrink window.
    --((modMask .|. shiftMask, xK_l     ), sendMessage MirrorExpand),  -- Expand window.

    -- Control workspaces.
    ((modMask 		       , xK_Left  ), moveTo Prev NonEmptyWS),   -- Switch to previous visible workspace.
    ((modMask 		       , xK_Right ), moveTo Next NonEmptyWS),   -- Switch to next visible workspace.
    ((modMask .|. mod1Mask , xK_Left  ), prevWS),                   -- Switch to previous workspace.
    ((modMask .|. mod1Mask , xK_Right ), nextWS),                   -- Switch to next workspace.
    ((modMask .|. shiftMask, xK_Left  ), shiftToPrev >> prevWS),    -- Shift window to previous workspace.
    ((modMask .|. shiftMask, xK_Right ), shiftToNext >> nextWS),    -- Shift window to next workspace.

    -- Control mpd (music player daemon).
    --((modMask .|. mod1Mask, xK_t     ), spawn "/usr/bin/mpc toggle"),
    --((modMask .|. mod1Mask, xK_s     ), spawn "/usr/bin/mpc status"),
    --((modMask .|. mod1Mask, xK_Left  ), spawn "/usr/bin/mpc prev"),
    --((modMask .|. mod1Mask, xK_Right ), spawn "/usr/bin/mpc next"),
    --((modMask             , xK_Down  ), spawn "/usr/bin/mpc volume -2"),
    --((modMask             , xK_Up    ), spawn "/usr/bin/mpc volume +2"),

    -- FIXME
    -- Control ALSA mixer.
    --((modMask              , xK_Up    ), spawn "~/bin/set_amixer_volume.sh 2+ | ~/bin/display_volume_bar.sh"),  -- Increase volume.
    --((modMask              , xK_Down  ), spawn "~/bin/set_amixer_volume.sh 2- | ~/bin/display_volume_bar.sh"),  -- Decrease volume.

    -- Media keys
    ((0,0x1008ff11                    ), lowerVolume 3 >> return ()),
    ((0,0x1008ff12                    ), toggleMute >> return ()),
    ((0,0x1008ff13                    ), raiseVolume 3 >> return ()),

    ((modMask              , xK_q     ), restart "xmonad" True),     -- Restart xmonad.
    ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))  -- Quit xmonad.

    ]

    ++

    -- mod-[1..9], Switch to workspace N.
    -- mod-shift-[1..9], Move client to workspace N.
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

    -- ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    --[((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --    | (key, sc) <- zip [xK_e, xK_w, xK_r] [0..]
    --    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

defaultTiled = ResizableTall 1 (3/100) (11/16) []

myLayoutHook
    = smartBorders
    $ avoidStruts
    $ mkToggle (NBFULL ?? EOT)
    $ (ResizableTall 1 (3/100) (9/16) []) ||| Mirror defaultTiled ||| Full

myLogHook xmproc = dynamicLogWithPP $ xmobarPP {
    ppCurrent = xmobarColor "green" "",
    ppHidden = xmobarColor "gray" "",
    ppHiddenNoWindows = const "",
    ppLayout = const "",  -- Hide layout name.
    ppOutput = hPutStrLn xmproc,
    ppSep = " <fc=#666666>|</fc> ",
    ppTitle = xmobarColor "orange" "" . shorten 120,
    ppUrgent = xmobarColor "white" "red" . wrap " " " " . xmobarStrip,
    ppVisible = wrap "<" ">",
    ppWsSep = " "
}

myManageHook = composeAll . concat $
    [
        [className =? c --> doFloat              | c <- myFloatAppsByClassName],
        [title     =? t --> doFloat              | t <- myFloatAppsByTitle],
        [className =? c --> doF (W.shift "web" ) | c <- myWebApps],
        [className =? c --> doF (W.shift "mail") | c <- myMailApps],
        [className =? c --> doF (W.shift "9"   ) | c <- myWs9Apps],
        [className =? c --> doF (W.shift "msg" ) | c <- msgApps]
    ]
    where
        myFloatAppsByClassName = [
			"Gnome-appearance-properties",
            "Lxappearance",
            "MPlayer",
            "mplayer2",
            "sun-awt-X11-XFramePeer",  -- Java applet launched from IntelliJ IDEA
            "Zenity"
            ]
        myFloatAppsByTitle = [
			"Iceweasel-Einstellungen"
            ]
        myWebApps = [
            "Iceweasel"
            ]
        myMailApps = [
            "Icedove"
            ]
        myWs9Apps = [
            "Chromium"
            ]
        ircApps = [
            "XChat"
            ]
        msgApps = [
            "icedove"
            ]

------------------------------------------------------------------------
-- workspaces

determineWorkspaceName :: String -> Map.Map String String -> String
determineWorkspaceName k map = case Map.lookup k map of
    Nothing -> k
    --Just v -> k ++ ":" ++ v
    Just v -> v

workspaceNumbers = map show [1..9]
workspaceNameSuffixes = Map.fromList [
    ("1", "web"),
    ("5", "mail")
    ]
--myWorkspaces = map (\x -> determineWorkspaceName x workspaceNameSuffixes) workspaceNumbers
--myWorkspaces = ["web"] ++ map show [2..9] ++ ["mail", "gimp", "im", "inkscape", "music", "office"]
myWorkspaces = ["web"] ++ map show [2..4] ++ ["mail"] ++ map show [6..9] ++ ["gimp", "♫"]

--
-- /workspaces

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad (defaults xmproc)

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
defaults xmproc = withUrgencyHook NoUrgencyHook defaultConfig {
    -- window decoration
    borderWidth = myBorderWidth,
    focusedBorderColor = myFocusedBorderColor,
    normalBorderColor = myNormalBorderColor,

    -- key bindings
    focusFollowsMouse = False,
    keys = myKeys,
    modMask = myModMask,

    -- hooks, layouts
    layoutHook = myLayoutHook,
    logHook = takeTopFocus <+> myLogHook xmproc,
    -- FIXME: Including `manageSpawn` make shifting windows to other workspaces fail.
    --manageHook = manageSpawn <+> manageDocks <+> myManageHook <+> manageHook defaultConfig,
    manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig,
    startupHook = myStartupHook,

    -- misc
    terminal = myTerminal,
    workspaces = myWorkspaces
    }
