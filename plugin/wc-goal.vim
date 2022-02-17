" Maintainer: J. O. Brickley <me@jobrickley.com>
"
" WCGoal: Set a wordcount goal.

if exists("g:loaded_wc_goal") || !has('popupwin')
  finish
endif
let g:loaded_wc_goal = 1

function! s:update_popup(remaining)
	let l:report_str = "Goal: " . string(a:remaining) . " words."
	let b:wc_goal_pop_id = popup_create(l:report_str, #{
		\ pos: 'topright',
		\ line: 1,
		\ col: &columns,
		\ })
endfunction

function! s:raise_popup()
	if exists('b:wc_goal')
		call s:update_popup(b:wc_goal - wordcount()["words"])
	endif
endfunction

function! s:hide_popup()
		if exists('b:wc_goal_pop_id')
			call popup_close(b:wc_goal_pop_id)
		endif
endfunction

function! WCGoal(...)
	if a:0 == 1
		let l:count = a:1
		if l:count > 0
			let b:wc_orig = wordcount()["words"]
			let b:wc_goal = l:count + b:wc_orig
		elseif l:count < 0
			if exists('b:wc_goal')
				let b:wc_goal = b:wc_goal + l:count
			endif
		elseif l:count == 0
			unlet b:wc_goal
			call s:hide_popup()
			augroup WCGoal | au! | augroup END
		endif
	endif
	if exists('b:wc_goal')
		let l:remaining = b:wc_goal - wordcount()["words"]
		call s:hide_popup()
		if l:remaining > 0
			call s:update_popup(l:remaining)
			augroup WCGoal
				autocmd CursorHoldI * call WCGoal()
				autocmd CursorHold * call WCGoal()
				autocmd BufEnter * call s:raise_popup()
				autocmd BufLeave * call s:hide_popup()
			augroup END
		else
			unlet b:wc_goal
			augroup WCGoal | au! | augroup END
		endif
	endif
endfunction

command! -nargs=? WCGoal call WCGoal(<f-args>)
