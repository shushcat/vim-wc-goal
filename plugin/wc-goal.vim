" Maintainer: J. O. Brickley <me@jobrickley.com>
"
" WCGoal: Set a wordcount goal.

if exists("g:loaded_wc_goal") || !has('popupwin')
  finish
endif
let g:loaded_wc_goal = 1

function! s:show_goal(...)
	if exists('b:wc_goal')
		if a:0 == 1
			let l:remaining = a:1
		else
			let l:remaining = s:words_remaining()
		endif
		let l:report_str = " Goal: " . string(l:remaining) . " words. "
		call s:close_popup()
		let b:wc_goal_pop_id = popup_create(l:report_str, #{
			\ pos: 'topright',
			\ line: 1,
			\ col: &columns,
			\ })
	endif
endfunction

function! s:words_remaining()
	return b:wc_goal - wordcount()["words"]
endfunction

function! s:close_popup()
		if exists('b:wc_goal_pop_id')
			call popup_close(b:wc_goal_pop_id)
		endif
endfunction

function! s:update_popup(remaining)
	call s:show_goal(a:remaining)
endfunction

function! s:create_augroup()
	augroup WCGoal
		au!
		autocmd CursorHoldI * call WCGoal()
		autocmd CursorHold * call WCGoal()
		autocmd BufEnter * call s:show_goal()
		autocmd BufLeave * call s:close_popup()
	augroup END
endfunction

function! s:remove_augroup()
	augroup WCGoal | au! | augroup END
endfunction

function! WCGoal(...)
	if !exists('b:wc_goal')
		call s:create_augroup()
	endif
	if a:0 == 1
		let l:count = a:1
		if l:count > 0
			let b:wc_goal = l:count + wordcount()["words"]
		elseif l:count < 0 && exists('b:wc_goal')
			let b:wc_goal = b:wc_goal + l:count
		elseif l:count == 0
			unlet b:wc_goal
			call s:close_popup()
			call s:remove_augroup()
		endif
	endif
	if exists('b:wc_goal')
		let l:remaining = s:words_remaining()
		if l:remaining > 0
			call s:update_popup(l:remaining)
		else
			call s:close_popup()
			unlet b:wc_goal
			call s:remove_augroup()
		endif
	endif
endfunction

command -nargs=? WCGoal call WCGoal(<f-args>)
