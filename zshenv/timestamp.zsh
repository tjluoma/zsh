zmodload zsh/datetime

timestamp () {
	strftime %F--%H.%M.%S "$EPOCHSECONDS"
}

timestamp_r () {
	strftime "%F %-I:%M:%S %p" "$EPOCHSECONDS" |\
	sed 's#AM#a.m.#g; s#PM#p.m.#g'
}
