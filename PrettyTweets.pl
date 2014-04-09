# vim keybinding for running this extension during testing
# yank the lines and execute them with :@" separately
# :nmap <F5> :w<CR>:!ttytter -timestamp="\%H:\%M" -exts=%:p<CR>
# :imap <F5> <Esc>:w<CR>:!ttytter -timestamp="\%H:\%M" -exts=%:p<CR>

$handle = sub {
	my $ref = shift;

	$color = ${'CC'.scalar(&$tweettype($ref,&descape($ref->{'user'}->{'screen_name'}),$ref->{'text'}))};
	$color = $OFF.$color;

	my $usercolor = $CYAN;
	my $menuselectcolor = $MAGENTA;
	my $textatcolor = $RED;

	my ($time, $ts) = &$wraptime($ref->{'created_at'}) if &getvariable('timestamp');
	my $menuselect = '<'.$ref->{'menu_select'}.'> ';
	my $timestamp = defined($ts)?'['.$ts.'] ':'';
	my $names;

	my $user_screen_name = &descape($ref->{'user'}->{'screen_name'});
	if ($user_screen_name eq "B******_N*****") {
		$usercolor = $BLUE;
	}

	if (defined $ref->{'user'}->{'name'}) {
		$names =
			"${EM}${usercolor}".
			&descape($ref->{'user'}->{'name'}).
			"$OFF".
			' ('.
			"${EM}${usercolor}".
			$user_screen_name .
			"$OFF".
			') '
		;
	} else {
		$names = "${EM}".$user_screen_name."$OFF ";
	}

	my $tweet_text = &descape($ref->{'text'});
	$color = $OFF.$YELLOW if ($tweet_text =~ /\@{$whoami}/);

	my $text = "${color}".$tweet_text."$OFF";
	my $bar = &descape("┃ ");
	$text =~ s/\\n/\n$bar/g;

	$text =~ s/(\@[\w_]+)/$textatcolor\1$OFF/g;
	$text =~ s/(https?\S+)/$textatcolor\1$OFF/g;

	print $streamout (
		&descape("┏━━ "),
		$names,
		"${menuselectcolor}".$menuselect."$OFF",
		$timestamp,
		"\n".&descape("┃ "),
		#(' ' x length $menuselect),
		$text,
		"\n",
	);
	return 1;
};

$dmhandle = sub {
	my $ref = shift;

	$color = ${'CCdm'};
	$color = $OFF.$color;

	my $usercolor = $GREEN;
	my $menuselectcolor = $MAGENTA;

	my ($time, $ts) = &$wraptime($ref->{'created_at'}) if &getvariable('timestamp');
	my $menuselect = '<DM d'.$ref->{'menu_select'}.'> ';
	my $timestamp = defined($ts)?'['.$ts.'] ':'';
	my $names;
	if (defined $ref->{'sender'}->{'name'}) {
		$names =
			"${EM}${usercolor}".
			&descape($ref->{'sender'}->{'name'}).
			"$OFF".
			' ('.
			"${EM}${usercolor}".
			&descape($ref->{'sender'}->{'screen_name'}).
			"$OFF".
			') '
		;
	} else {
		$names = "${EM}".&descape($ref->{'sender'}->{'screen_name'})."$OFF ";
	}
	my $text = "${color}".&descape($ref->{'text'})."$OFF";
	my $bar = &descape("┃ ");
	$text =~ s/\\n/\n$bar/g;

	print $streamout (
		&descape("┏━━ "),
		$names,
		"${menuselectcolor}".$menuselect."$OFF",
		$timestamp,
		"\n".&descape("┃ "),
		#(' ' x length $menuselect),
		$text,
		"\n",
	);
	return 1;
};
