% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/writable.R
\docType{class}
\name{Writeable}
\alias{Writeable}
\title{Writeable class}
\format{
\code{\link{R6Class}} object.
}
\value{
Object of \code{\link{R6Class}} .
}
\description{
Writable streams class
}
\keyword{data}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{Writeable$new()}}
\item \href{#method-write}{\code{Writeable$write()}}
\item \href{#method-read}{\code{Writeable$read()}}
\item \href{#method-pipe}{\code{Writeable$pipe()}}
\item \href{#method-unpipe}{\code{Writeable$unpipe()}}
\item \href{#method-pause}{\code{Writeable$pause()}}
\item \href{#method-resume}{\code{Writeable$resume()}}
\item \href{#method-setEncoding}{\code{Writeable$setEncoding()}}
\item \href{#method-isPaused}{\code{Writeable$isPaused()}}
\item \href{#method-unshift}{\code{Writeable$unshift()}}
\item \href{#method-destroy}{\code{Writeable$destroy()}}
\item \href{#method-push}{\code{Writeable$push()}}
\item \href{#method-onClose}{\code{Writeable$onClose()}}
\item \href{#method-onData}{\code{Writeable$onData()}}
\item \href{#method-onEnd}{\code{Writeable$onEnd()}}
\item \href{#method-onError}{\code{Writeable$onError()}}
\item \href{#method-onReadable}{\code{Writeable$onReadable()}}
\item \href{#method-clone}{\code{Writeable$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$new(options = list())}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-write"></a>}}
\if{latex}{\out{\hypertarget{method-write}{}}}
\subsection{Method \code{write()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$write(chunk)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-read"></a>}}
\if{latex}{\out{\hypertarget{method-read}{}}}
\subsection{Method \code{read()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$read(size = NULL)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-pipe"></a>}}
\if{latex}{\out{\hypertarget{method-pipe}{}}}
\subsection{Method \code{pipe()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$pipe(destination, options = list())}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-unpipe"></a>}}
\if{latex}{\out{\hypertarget{method-unpipe}{}}}
\subsection{Method \code{unpipe()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$unpipe(destination)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-pause"></a>}}
\if{latex}{\out{\hypertarget{method-pause}{}}}
\subsection{Method \code{pause()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$pause()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-resume"></a>}}
\if{latex}{\out{\hypertarget{method-resume}{}}}
\subsection{Method \code{resume()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$resume()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-setEncoding"></a>}}
\if{latex}{\out{\hypertarget{method-setEncoding}{}}}
\subsection{Method \code{setEncoding()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$setEncoding()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-isPaused"></a>}}
\if{latex}{\out{\hypertarget{method-isPaused}{}}}
\subsection{Method \code{isPaused()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$isPaused()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-unshift"></a>}}
\if{latex}{\out{\hypertarget{method-unshift}{}}}
\subsection{Method \code{unshift()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$unshift(chunk)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-destroy"></a>}}
\if{latex}{\out{\hypertarget{method-destroy}{}}}
\subsection{Method \code{destroy()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$destroy()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-push"></a>}}
\if{latex}{\out{\hypertarget{method-push}{}}}
\subsection{Method \code{push()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$push(chunk, encoding)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-onClose"></a>}}
\if{latex}{\out{\hypertarget{method-onClose}{}}}
\subsection{Method \code{onClose()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$onClose(handler, unsubscribe = FALSE)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-onData"></a>}}
\if{latex}{\out{\hypertarget{method-onData}{}}}
\subsection{Method \code{onData()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$onData(handler, unsubscribe = FALSE)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-onEnd"></a>}}
\if{latex}{\out{\hypertarget{method-onEnd}{}}}
\subsection{Method \code{onEnd()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$onEnd(handler, unsubscribe = FALSE)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-onError"></a>}}
\if{latex}{\out{\hypertarget{method-onError}{}}}
\subsection{Method \code{onError()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$onError(handler, unsubscribe = FALSE)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-onReadable"></a>}}
\if{latex}{\out{\hypertarget{method-onReadable}{}}}
\subsection{Method \code{onReadable()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$onReadable(handler, unsubscribe = FALSE)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Writeable$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
