" WindowSwap!

let s:markedWinNum = []

function! WindowSwap#MarkWindowSwap()
   call WindowSwap#SetMarkedWindowNum( tabpagenr(), winnr() )
endfunction

function! WindowSwap#DoWindowSwap()
   if !WindowSwap#HasMarkedWindow()
      echom "WindowSwap: No window marked to swap! Mark a window first."
      return
   endif
   "Mark destination
   let curTab = tabpagenr()
   let curNum = winnr()
   let curBuf = bufnr( "%" )
   let targetWindow = WindowSwap#GetMarkedWindowNum()
   exe "tabn " . targetWindow[0]
   exe targetWindow[1] . "wincmd w"
   "Switch to source and shuffle dest->source
   let markedBuf = bufnr( "%" )
   "Hide and open so that we aren't prompted and keep history
   exe 'hide buf' curBuf
   "Switch to dest and shuffle source->dest
   exe "tabn " . curTab
   exe curNum . "wincmd w"
   "Hide and open so that we aren't prompted and keep history
   exe 'hide buf' markedBuf
   call WindowSwap#ClearMarkedWindowNum()
endfunction

function! WindowSwap#EasyWindowSwap()
   if WindowSwap#HasMarkedWindow()
      call WindowSwap#DoWindowSwap()
   else
      call WindowSwap#MarkWindowSwap()
   endif
endfunction

function! WindowSwap#GetMarkedWindowNum()
   return s:markedWinNum
endfunction

function! WindowSwap#SetMarkedWindowNum(tab,win)
   let s:markedWinNum = [a:tab,a:win]
endfunction

function! WindowSwap#ClearMarkedWindowNum()
   let s:markedWinNum = []
endfunction

function! WindowSwap#HasMarkedWindow()
   if WindowSwap#GetMarkedWindowNum() == []
      return 0
   else
      return 1
   endif
endfunction

function! WindowSwap#DeprecationNotice()
   if g:windowswap_mapping_deprecation_notice
      echom "This default mapping is deprecated and will be removed in the future. Please see :help windowswap-functions."
      return
   endif
endfunction

function! WindowSwap#DeprecatedMark()
   call WindowSwap#DeprecationNotice()
   call WindowSwap#MarkWindowSwap()
endfunction

function! WindowSwap#DeprecatedDo()
   call WindowSwap#DeprecationNotice()
   call WindowSwap#DoWindowSwap()
endfunction

