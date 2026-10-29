% acme.bst: numbered references in the style
%   Last, First, et al. "Title." Venue. Year.
% Entries are listed in citation order. The venue is taken from the
% journal field, else booktitle, else howpublished (use howpublished for
% arXiv preprints and theses, e.g. "arXiv:2410.23299").

ENTRY
  { author title journal booktitle howpublished year }
  {}
  { label }

INTEGERS { nameptr numnames }

STRINGS { s t u }

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {format.authors}
{ author 's :=
  s num.names$ 'numnames :=
  s #1 "{vv~}{ll}{, ff}{, jj}" format.name$ 't :=
  numnames #3 >
    { t ", et~al." * 't := }
    { #2 'nameptr :=
      { nameptr numnames > not }
      { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 'u :=
        u "others" =
          { t ", et~al." * 't := }
          { nameptr numnames =
              { t ", and " * u * 't := }
              { t ", " * u * 't := }
            if$
          }
        if$
        nameptr #1 + 'nameptr :=
      }
      while$
    }
  if$
  t
}

FUNCTION {venue}
{ journal empty$
    { booktitle empty$
        { howpublished }
        { booktitle }
      if$
    }
    { journal }
  if$
}

FUNCTION {entry.out}
{ newline$
  "\bibitem{" cite$ * "}" * write$
  newline$
  format.authors add.period$ " ``" * title add.period$ * "'' " *
  venue add.period$ * " " * year * "." * write$
  newline$
}

FUNCTION {article} { entry.out }
FUNCTION {inproceedings} { entry.out }
FUNCTION {incollection} { entry.out }
FUNCTION {misc} { entry.out }
FUNCTION {phdthesis} { entry.out }
FUNCTION {techreport} { entry.out }
FUNCTION {book} { entry.out }
FUNCTION {default.type} { entry.out }

READ

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{99}" write$
  newline$
}

EXECUTE {begin.bib}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$
  newline$
}

EXECUTE {end.bib}
