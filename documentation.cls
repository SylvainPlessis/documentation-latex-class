\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{documentation}[13/06/2014 personnal class for model doc, v0.0]

\LoadClass[twoside]{report}

\RequirePackage{booktabs}
\RequirePackage{geometry}
\RequirePackage{amsmath}
\RequirePackage{multicol}
\RequirePackage{multirow}
\RequirePackage{array}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{lineno}
\RequirePackage[autolanguage]{numprint}
\RequirePackage[version=3,arrows=pgf-filled]{mhchem}
\RequirePackage{fancyhdr}
\RequirePackage{longtable}
\RequirePackage[round]{natbib}
\RequirePackage[strict]{changepage} % remark environment
\RequirePackage[linkcolor=black,colorlinks=true,citecolor=black,urlcolor=blue]{hyperref}

%%%%%%%%%%%%%%%ù
%
% layout
%
%%%%%%%%%%%%%
\setlength{\marginparwidth}{103pt}
\setlength{\marginparsep}{5pt}
\addtolength{\textheight}{1cm}
\newlength{\rightside}
\newlength{\leftside}
\newcommand{\set@length@rightside}[1]
{\checkoddpage%
\setlength{\leftside}{\marginparwidth}
\setlength{\rightside}{\paperwidth - 0.5\marginparwidth - \textwidth - \marginparsep - \hoffset - 0.8in}
\ifoddpage\setlength{#1}{\leftside}\else\setlength{#1}{\rightside}\fi
}
\newcommand{\set@length@leftside}[1]
{\checkoddpage%
\setlength{\leftside}{\marginparwidth}
\setlength{\rightside}{\paperwidth - 0.5\marginparwidth - \textwidth - \marginparsep - \hoffset - 0.8in}
\ifoddpage\setlength{#1}{\rightside}\else\setlength{#1}{\leftside}\fi
}


%% config
\graphicspath{{./figs/}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%% meta-meta-function
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  make@something: 
%%    - arg 1: something (name/root of macros)
%%    - arg 2: font (typically family)
%%    - opt arg: other arg for font (typically shape, default `upshape')
\newcommand{\make@}[3][upshape]
{%
%%
%%% create font@something macro
\expandafter\gdef\csname font@#2\endcsname##1{%
{\csname#1\endcsname\csname#3\endcsname{##1}}%
}%
%%
%% create make@something meta macro
\expandafter\gdef\csname make@#2\endcsname##1{%
\expandafter\gdef\csname ##1\endcsname{\csname font@#2\endcsname{##1}}%
}
%%
%% create the \something macro
\expandafter\gdef\csname#2\endcsname##1{\csname font@#2\endcsname{##1}}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%% meta functions and definitions
%%%% some global and classics
%%     - program (Doxygen, ...)
%%     - library (Antioch, GRINS, LibMesh, ...)
%%     - object  (KineticsType, ...)
%%     - prog    (double, C++, std::string, ...)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% meta font for prog below
\newcommand{\prog@type}[1]{\textcolor{green!60!black}{\object{#1}}}

%% meta function
\make@{program}   {sf}
\make@{library}   {tt}
\make@[bf]{object}{tt}
\make@{file}      {sf}
\make@{prog}      {prog@type}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% general macros and meta-macros
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% unit management here
%% default parser is `\,'
%% redefine \unit@parser in
%% preamble to change this
%%
%% !!!  always print `\,' in documentation  !!!
%% !!!  only the pdf output will be changed !!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\gdef\unit@parser{\;}
\newcommand{\prev}{\relax}
\newcommand{\parse@unit}[1]{%
\let\go@next\parse@unit%
\ifx#1\relax%%
  \let\go@next=\relax%
\else%
  \ifx#1\,\unit@parser\else%
    \ifx^#1 \renewcommand{\prev}{^}\else% if superscript
        \ifx_#1\renewcommand{\prev}{_}\else% if subscript
         \if_\prev \prev{#1}\renewcommand{\prev}{\relax}\else
          \if^\prev \prev{#1}\renewcommand{\prev}{\relax}\else#1\fi\fi
        \fi%
    \fi%
  \fi
\fi%
\go@next%
}
\newcommand{\unit}[1]{\ensuremath{\mathtt{\protect\parse@unit#1\relax}}}
\newcommand{\nounit}{\unit{no~unit}}

%%% physical constants equation management
\newcommand{\make@meta@equation}[7]
{
\expandafter\gdef\csname#2\endcsname{\ensuremath{#3}}%                                         \"name"     produces "symbol"
\expandafter\gdef\csname#2val\endcsname{\csname#7\endcsname{#4}\ifnum#1=0\else\,10^{#1}\fi}%   \"name"val  produces "value"
\expandafter\gdef\csname#2dval\endcsname{\csname#7\endcsname{#5}}%                             \"name"dval produces "dvalue"
\expandafter\gdef\csname#2num\endcsname{\csname#7\endcsname{#4}\ifnum#5=0\else%
                                \,(\csname#2dval\endcsname)\fi\ifnum#1=0\else\,10^{#1}\fi}%    \"name"num  produces "value (dvalue)"
\expandafter\gdef\csname#2unit\endcsname{\unit{#6}}%                                           \"name"unit produces "unit"
\expandafter\gdef\csname#2Equation\endcsname{% %% equation
 \ensuremath{\csname#2\endcsname = \csname#2num\endcsname~\csname#2unit\endcsname}}%           \"name"Equation produces "symbol = value (dvalue)~unit"
}
\newcommand{\make@equation}[6][0] %% name, symbol, value, dvalue, unit | symbol = value (dvalue) \unit{unit}
{%
 \make@meta@equation{#1}{#2}{#3}{#4}{#5}{#6}{numprint}
}
\newcommand{\make@litteralEquation}[4] %% name, symbol, expression, unit | symbol = expression \unit{unit}
{%
 \make@meta@equation{0}{#1}{#2}{#3}{0}{#4}{relax}
}

%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%% versions
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcounter{vmajor}
\newcounter{vmedium}
\newcounter{vminor}

\newcommand{\version}[3]{%
\setcounter{vmajor}{#1}
\setcounter{vmedium}{#2}
\setcounter{vminor}{#3}
}
\newcommand{\theversion}{\thevmajor.\thevmedium.\thevminor}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%  stuffs start here
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%
%%
%% 'cause I'm lazy 
\newcommand{\ie}[1]{\textit{i.e.}\ #1}

%%%%%%%%%%%%%%%%%
%%
%%% general stuff
\newcommand{\dd}{\ensuremath{\mathrm{d}}}
\newcommand{\optional@sub} [2][\relax]{\ifx#1\relax\ensuremath{#2}\else\ensuremath{{{#2}_{#1}}}\fi}
\newcommand{\optional@@sub}[2][\relax]{\ifx#1\relax\ensuremath{#2}\else\ensuremath{{#2}_{#1}}\fi}
\newcommand{\d@d} [2]{\ensuremath{\frac{\partial#2}{\partial #1}}}
\newcommand{\dd@d}[2]{\ensuremath{\frac{\dd #2}{\dd #1}}}

%%%%%%%%%%%%%%%%%
%% chemical equation 
\newcounter{chemeq}
\setcounter{chemeq}{0}
\renewcommand{\thechemeq}{$\chi$~\thesection-\arabic{chemeq}}
\newenvironment{chemicalEquation}
{\begin{displaymath}}
{\refstepcounter{chemeq}\tag{\thechemeq}%
\end{displaymath}}
\@addtoreset{chemeq}{section}

%%%%%%%%%%%%%%%%%%%%
% equation with ref to object
%%%%%%%
%% first, renew the tag
\newlength{\EqCodew}
\newlength{\maxwidth}
\newcommand{\print@Object}{\relax}
\newenvironment{equationCode}[1]
{%
\renewcommand{\theequation}{\arabic{chapter}.\arabic{equation}\protect\print@Object}
\settowidth{\EqCodew}{\object@code{#1}}%
\set@length@rightside{\maxwidth}
\ifdim\EqCodew>\maxwidth
  \setlength{\EqCodew}{\maxwidth}%
\fi
\renewcommand{\print@Object}{\makebox[0pt][l]{\rule{1ex+0.5\marginparsep}{0pt}\resizebox{\EqCodew}{!}{\object@code{#1}}}}
\begin{equation}
}
{\end{equation}}

%%%%%%%
% remarks
%%%%%%%
\newif\if@remark%
\newlength{\remark@sep}
\setlength{\remark@sep}{12pt}
\newenvironment{remark}
{%
\renewcommand{\labelitemi}{\textemdash}
\addtolength{\leftmargin}{15pt}
\par
\noindent\rule{\linewidth}{0.4pt}\\*%
\underline{\bf Remark}:%
\begin{adjustwidth}{\remark@sep}{}
\@remarktrue%
\small\sf%
}
{\end{adjustwidth}
\@remarkfalse%
\noindent\rule{\linewidth}{0.4pt}}

%%%%%%%%%%%%%%%%%%%%%%%%
% warning
%%%%%%%
\newcommand{\warningsign}{%
\begin{tikzpicture}[baseline = (x.base)]
\node[regular polygon, regular polygon sides=3,draw=white,double=red,
      fill=red,text=white,font=\bf\large,rounded corners] (x) {!};
\end{tikzpicture}
}
\newcommand{\warning}[1]{%
\hspace{-1in}\warningsign\textbf{\textcolor{red}%
{\large\sc #1}}
}

%%%%%%%%%%%%%%%
%%% * pretty picture next to \section
%%% * picture absolutely in center of page
%%%
%%% \section:
%%% from report.cls, adapated
%%% added the makegraph stuff

\newcommand{\makegraph}      {\relax}
\newcommand{\makeno@graph}   {\renewcommand{\makegraph}{\relax}}
\newlength{\graph@size}
\newlength{\graph@length}
\newcommand{\make@graph@length}{\set@length@leftside{\graph@length}}
\newcommand{\print@graph} [1]{{\includegraphics[width=\graph@length]{#1}}}
\newcommand{\make@graph}  [1]{\renewcommand{\makegraph}{\noindent\make@@graph{\print@graph{#1}\rule{1ex}{0pt}}}}%
\newcommand{\make@@graph} [1]{\makebox[0pt][r]{\raisebox{-0.5\graph@size}[0pt][0pt]{#1}}}%
\newcommand{\make@@@graph}[1]{\ifx#1\relax%
                               \makeno@graph%
                                \else%
                               \make@graph@length%
                               \settoheight{\graph@size}{\print@graph{#1}}\make@graph{#1}%
                              \fi%
                            }%
\renewcommand\section[1][\relax]{\make@@@graph{#1}%
                                 \@startsection {section}{1}{\z@}%
                                 {-3.5ex \@plus -1ex \@minus -.2ex}%
                                 {2.3ex \@plus.2ex}%
                                 {\makegraph\normalfont\Large\bfseries}
                                }
%%%%%%%%%%%%%%%%
%% graph, by default all page width
%%%%%%%
\newlength{\tocenter}
\newcommand{\graphAtPaperCenter}[2][width=\paperwidth]
{%
\AtPaperCenter{\includegraphics[#1]{#2}}\par
}
\newcommand{\AtPaperCenter}[1]{%
%%%% from geometry package
%% inner/outer margin ratio 2:3
%% => \parperwidth - \textwidth = 5
%% center = (inner +) 0.5\textwidth + (\parperwidth - \textwidth)/10 %% offset from inner (odd page)
%% center = (outer +) 0.5\textwidth - (\parperwidth - \textwidth)/10 %% offset from outer (even page)
%%%%%%%%%%%
\setlength{\tocenter}{\paperwidth}
\addtolength{\tocenter}{-\textwidth} % + \remark@sep
\checkoddpage
\ifoddpage% odd
  \setlength{\tocenter}{0.1\tocenter}
\else% even
  \setlength{\tocenter}{-0.1\tocenter}
\fi%
\addtolength{\tocenter}{0.5\textwidth}% + 0.5\remark@sep
\if@remark\addtolength{\tocenter}{-1.5\remark@sep}\fi %
\noindent\hspace{\tocenter}\makebox[0pt]{#1}
}

%\newcommand\chapter{\if@openright\cleardoublepage\else\clearpage\fi
%                    \thispagestyle{plain}%
%                    \global\@topnum\z@
%                    \@afterindentfalse
%                    \secdef\@chapter\@schapter}

\endinput