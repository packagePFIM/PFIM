#' @title FedorovWynnAlgorithm Class
#' @name FedorovWynnAlgorithm
#' @description The class \code{FedorovWynnAlgorithm} implements the FedorovWynn algorithm.
#' The class \code{FedorovWynnAlgorithm} implements the Fedorov-Wynn exchange
#' algorithm. This algorithm is used for discrete design optimization,
#' iteratively adding or exchanging elementary protocols to maximize the
#' determinant of the Fisher Information Matrix (D-optimality).
#' @inheritParams Optimization
#' @param elementaryProtocols A list of elementary protocols available for selection.
#' @param numberOfSubjects A numeric vector specifying the number of subjects per arm.
#' @param proportionsOfSubjects A numeric vector of subject proportions for each protocol.
#' @param showProcess A logical indicating whether to display optimization progress.
#' @param FedorovWynnAlgorithmOutputs A list storing the results of the optimization.
#' @include Optimization.R
#' @examples
#' \dontrun{
#'
#' # Example from Vignette 1: Population FIM optimization using Fedorov-Wynn
#'
#' # 1. Initialize the Optimization object
#' optiFW <- Optimization(
#'   name                = "FedorovWynn_Optimization",
#'   modelEquations      = modelEquations,
#'   modelParameters     = modelParameters,
#'   modelError          = modelError,
#'   optimizer           = "FedorovWynnAlgorithm",
#'   optimizerParameters = list(
#'     elementaryProtocols   = initialElementaryProtocols,
#'     numberOfSubjects      = numberOfSubjects,
#'     proportionsOfSubjects = proportionsOfSubjects,
#'     showProcess           = TRUE
#'   ),
#'   designs             = list(designConstraint),
#'   fimType             = "population",
#'   outputs             = list("RespPK" = "Cc", "RespPD" = "E"),
#'   odeSolverParameters = list(atol = 1e-8, rtol = 1e-8)
#' )
#'
#' # 2. Run the optimization algorithm
#' optimizationResults = run(optiFW)
#'
#' # 3. Display the optimized design and Fisher Information Matrix
#' show(optimizationResults)
#'
#' }
#' @template copyright
#' @export

FedorovWynnAlgorithm = new_class(
  "FedorovWynnAlgorithm",
  package    = "PFIM",
  parent = .Optimization_S7,
  properties = list(
    elementaryProtocols         = new_property(class_list,    default = list()),
    numberOfSubjects            = new_property(class_vector,  default = 0.0),
    proportionsOfSubjects       = new_property(class_vector,  default = 0.0),
    showProcess                 = new_property(class_logical,  default = FALSE),
    FedorovWynnAlgorithmOutputs = new_property(class_list,    default = list())
  ),
  # Explicit constructor required so that do.call(FedorovWynnAlgorithm,
  # c(parentSlots, fwSlots)) populates every slot correctly.
  # S7 auto-generated constructors only declare the class's own properties;
  # parent-class slots passed via do.call() would otherwise be silently dropped,
  # leaving designs / modelEquations / ... at their empty defaults and causing
  # the validator to fire during the first prop<- assignment inside run().
  constructor = function(
    # ── FW-specific properties ──────────────────────────────────────────────
    elementaryProtocols         = list(),
    numberOfSubjects            = 0.0,
    proportionsOfSubjects       = 0.0,
    showProcess                 = FALSE,
    FedorovWynnAlgorithmOutputs = list(),
    # ── Inherited Optimization properties (forwarded from the factory) ──────
    optimisationDesign           = list(),
    optimisationAlgorithmOutputs = list(),
    name                         = character(0),
    modelParameters              = list(),
    modelEquations               = list(),
    modelFromLibrary             = list(),
    modelError                   = list(),
    designs                      = list(),
    outputs                      = list(),
    fimType                      = character(0),
    odeSolverParameters          = list()
  ) {
    new_object(
      # Build a fully-populated Optimization parent instance by calling the
      # original S7 class constructor directly (not the factory wrapper), so
      # there is no recursive factory dispatch.
      .parent = .Optimization_S7(
        optimisationDesign           = optimisationDesign,
        optimisationAlgorithmOutputs = optimisationAlgorithmOutputs,
        name                         = name,
        modelParameters              = modelParameters,
        modelEquations               = modelEquations,
        modelFromLibrary             = modelFromLibrary,
        modelError                   = modelError,
        designs                      = designs,
        outputs                      = outputs,
        fimType                      = fimType,
        odeSolverParameters          = odeSolverParameters
      ),
      elementaryProtocols         = elementaryProtocols,
      numberOfSubjects            = numberOfSubjects,
      proportionsOfSubjects       = proportionsOfSubjects,
      showProcess                 = showProcess,
      FedorovWynnAlgorithmOutputs = FedorovWynnAlgorithmOutputs
    )
  }
)

plotFrequenciesFedorovWynnAlgorithm = new_generic( "plotFrequenciesFedorovWynnAlgorithm", c( "optimization", "optimizationAlgorithm" ) )

# ==============================================================================
#' @title FedorovWynnAlgorithm with Rcpp
#' @name FedorovWynnAlgorithm_Rcpp
#' @description
#' Implementation of the Fedorov-Wynn algorithm in C++
#' via Rcpp. This function handles the heavy matrix computations and
#' exchange logic required for D-optimal design.
#' @param protocols_input List of protocol definitions.
#' @param ndimen_input Dimensions of the problem.
#' @param nbprot_input Number of protocols.
#' @param numprot_input Protocol indices.
#' @param freq_input Frequencies of protocols.
#' @param nbdata_input Data point counts.
#' @param vectps_input Sampling times vector.
#' @param fisher_input Fisher matrix inputs.
#' @param nok_input Error code/status.
#' @param protdep_input Initial protocol indices.
#' @param freqdep_input Initial frequencies.
#' @return A list containing optimal frequencies, sampling times, and the resulting FIM.
#' @export
# ==============================================================================

FedorovWynnAlgorithm_Rcpp = function( protocols_input,  ndimen_input, nbprot_input,
                                      numprot_input, freq_input, nbdata_input,
                                      vectps_input, fisher_input, nok_input,
                                      protdep_input, freqdep_input ){
  incltxtFedorovWynnAlgorithm = '

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h> 	/* Mathematical functions */
#include <time.h>	/* Function time used to initialise the random number generator */
#include <float.h>	/* Implementation related constants */
#include <signal.h>	/* Signal handling used to detect arithmetic errors */
#include <Rcpp.h> /* Rcpp */

using namespace Rcpp;

#define FTOL 1e-6 /* Minimal change in criterion during optimisation step*/
#define FREQMIN 1e-8 /* Minimal frequency for a protocol to be kept */
#define EPSILON DBL_EPSILON
#define CRI_MAX 1e30 /* maximum value for criterium, used to test correct comp*/
#define NRANSI
#define tol 0.0001
#define SWAP(a,b) {temp=(a);(a)=(b);(b)=temp;}
#define TINY 1.0e-20
#define SMALL 1.0e-7
#define IA 16807  	/*definition des constantes pour ran1 */
#define IM 2147483647
#define AM (1.0/IM)
#define IQ 127773
#define IR 2836
#define NTAB 32
#define NDIV (1+(IM-1)/NTAB)
#define EPS 1.2e-7
#define RNMX (1.0-EPS)
#define FREE_ARG char*

typedef struct PROTOC /* Structure defi
ning an individual or elementary protocol */
{
	int	ntps; /* Number of sampling times */
	double	*tps; /* Vector of the sampling times */
	int	ndim; /* Number of random effects (=> size of matrices)*/
	double	*fisher; /* Fisher information matrix of the individual protocol */
} PROTOC;

typedef struct POPROT /* Structure defining a population protocol */
{
	int 	maxnp; /* Max number of individual protocols, needed for memory allocation*/
	int	np; /* Number of individual protocols WARNING np<=maxnp !*/
	int	ndim; /* Number of random effects (=> size of matrices)*/
	int	*num; /* In this program we keep trace of the index of individual protocols*/
	PROTOC	*pind; /* In NPML we would only need the individual protocols themselves*/
	double	*freq; /* Frequency of each individual protocols */
	double 	*fisher; /* Fisher information matrix of population protocol */
	double 	*finv; /* Inverse of the Fisher information matrix */
	double	det; /* Determinant of the matrix */
} POPROT;

typedef struct matrix
{
	int 	nrow;
	int	ncol;
	double	**m;
} matrix;


/******************************************************************************
   Construction and destruction of structures
*******************************************************************************/

void PROTOC_alloc( PROTOC *p, int ntps, int ndim)
{
	p->ntps = ntps;
	p->tps = (double *)calloc( p->ntps, sizeof(double));
	assert(p->tps!=NULL);
	p->ndim=ndim;
	p->fisher = (double *)calloc( p->ndim*(p->ndim+1)/2, sizeof(double));
	assert(p->fisher!=NULL);
	return;
}

POPROT *POPROT_alloc(int np,int ndim,int maxnp)
{	POPROT *p;
	p = (POPROT *)malloc(sizeof(POPROT));
	assert(p!=NULL);

	p->maxnp=maxnp;
	p->np = np;
	p->ndim=ndim;
/* Keep trace of the index of the individual protocols */
	p->num = (int *)calloc( p->maxnp, sizeof(int));
	assert(p->num!=NULL);
	p->pind = (PROTOC *)calloc( p->maxnp, sizeof(PROTOC));
	assert(p->pind!=NULL);
	p->freq = (double *)calloc( p->maxnp, sizeof(double));
	assert(p->freq!=NULL);
	p->fisher = (double *)calloc( p->ndim*(p->ndim+1)/2, sizeof(double));
	assert(p->fisher!=NULL);
	p->finv = (double *)calloc( p->ndim*(p->ndim+1)/2, sizeof(double));
	assert(p->finv!=NULL);
	p->det=1.0;
	return p;
}

void PROTOC_copy(PROTOC *p,PROTOC *p1)
{
	int i,ndat;

	for(i=0;i<p->ntps;i++) {p1->tps[i]=p->tps[i];}
	ndat=(int)(p->ndim*(p->ndim+1))/2;
	for(i=0;i<ndat;i++) {p1->fisher[i]=p->fisher[i];

		}
	return;
}

matrix *matrix_create(int nrow, int ncol)
{	int i,j;
	matrix *mat;
	mat = (matrix *)malloc(sizeof(matrix));
	assert(mat!=NULL);
	mat->nrow=nrow;
	mat->ncol=ncol;
	mat->m = (double **)calloc( nrow, sizeof(double *));
	assert(mat->m!=NULL);
	for( i=0 ; i<nrow ; i++ )
	{
	mat->m[i] = (double *)calloc( ncol, sizeof(double));
	assert(mat->m[i]!=NULL);
	for( j=0 ; j<ncol ; j++ )
		mat->m[i][j]=0.0;
	}
	return mat;

}

void PROTOC_print(PROTOC *p)
{	int i,icas=0,j;
	fprintf(stderr,"Temps du protocole :");
	for (i=0;i<p->ntps;i++) {}
	for (i=0;i<p->ndim;i++) {
		for (j=0;j<=i;j++) {
			icas++;}
	}
	return;
}

void POPROT_print(POPROT *pop,int nofish)
{	int i,icas=0,j,k;

	for(i=0;i<pop->np;i++)
	{
		for (j=0;j<pop->pind[i].ntps;j++)
		{
		}

		if(nofish==1) {

		icas=0;
		for (j=0;j<pop->pind[i].ndim;j++)
		{
			for (k=0;k<=j;k++)
			{

				icas++;
			}

		}

		}
	}
	return;
}

void POPROT_printfisher(POPROT *pop)
{	int icas,j,k;


	icas=0;
	for (j=0;j<pop->ndim;j++)
	{
		for (k=0;k<=j;k++)
		{

		icas++;
		}

	}

	icas=0;
	for (j=0;j<pop->ndim;j++)
	{
		for (k=0;k<=j;k++)
		{

		icas++;
		}

	}
	return;
}

void POPROT_calculefisher(POPROT *pop)
{	int i,iprot;

	for(i=0;i<pop->ndim*(pop->ndim+1)/2;i++)
	{
		pop->fisher[i]=0.0;
		for(iprot=0;iprot<pop->np;iprot++)
		{
	pop->fisher[i]=pop->fisher[i]+pop->pind[iprot].fisher[i]*pop->freq[iprot];
		}
	}
}

void matrix_print(matrix *mat)
{	int i,j;

	for (i=0;i<mat->nrow;i++) {
		for (j=0;j<mat->ncol;j++) {
}
}
	return;
}

void PROTOC_destroy(PROTOC *p)
{
	free(p->fisher);
	free(p->tps);
}

void POPROT_destroy(POPROT *p)
{
	free(p->finv);
	free(p->fisher);
	free(p->freq);
	free(p->pind);
	free(p->num);
}

void matrix_destroy(matrix *mat)
{
	int i;
	for( i=0 ; i<mat->nrow ; i++ )
	{
	free(mat->m[i]);
	}
	free(mat->m);
}

/******************************************************************************
   Fonctions calculatoires
*******************************************************************************/

double matrace(int iprot,PROTOC *prot,POPROT *pop);
double lik(POPROT *pop);
void lubksb(double **a, int n, int *indx, double b[]);
int ludcmp(double **a, int n, int *indx, double *d);

/* Random number generator */
double randu(double x);
double gauss1(long *idum);
float ran1(long *idum);

/******************************************************************************
   Defining global variables (see variables_npml.txt for details)
*******************************************************************************/

volatile sig_atomic_t ierr=0;	/* Parameter signaling a SIGFPE error */
				/* to be used with a signal handler */
long seed=-10;     	/* graine du generateur aleatoire */

/******************************************************************************

/******************************************************************************
   Initialisation et ajout de protocole ?l?mentaire
*******************************************************************************/

POPROT *initprot(PROTOC *allprot, IntegerVector protdep, NumericVector freqdep)

{
	int i,ij,np,nmax;

	POPROT *mypop;

	np=protdep[0];

	nmax=allprot[0].ndim*(allprot[0].ndim+1)/2+1;
	mypop=POPROT_alloc(np,allprot[0].ndim,nmax);

	for(i=0;i<np;i++) {
		mypop->freq[i]=freqdep[i];
		mypop->num[i]=protdep[i+1]-1;
		ij=mypop->num[i];
		PROTOC_alloc(&mypop->pind[i],allprot[ij].ntps,allprot[ij].ndim);
		PROTOC_copy(&allprot[ij],&mypop->pind[i]);
	}

return mypop;

}

/******************************************************************************
   Optimisation de protocole
*******************************************************************************/

void tassement(POPROT *pop)
{	int i,idec=0,np;
	np=pop->np;
	for(i=0;i<pop->np;i++)
	{
		if(pop->freq[i]<FREQMIN)
		{
			idec++;
			np--;
		}
		else
		{
			if (idec>0)
			{
				pop->freq[i-idec]=pop->freq[i];
				pop->num[i-idec]=pop->num[i];

				PROTOC_destroy(&pop->pind[i-idec]);
	PROTOC_alloc(&pop->pind[i-idec],pop->pind[i].ntps,pop->pind[i].ndim);
				PROTOC_copy(&pop->pind[i],&pop->pind[i-idec]);

			}
		}
	}

	for(i=np;i<pop->np;i++) PROTOC_destroy(&pop->pind[i]);
	pop->np=np;
	return;
}




int ajout(PROTOC *allprot,POPROT *pop,int nprot)
{	double cri,xmul,xtest,ifin=0,xdim,rcalc;
	int iprot,j,deja,qajout=-1;

	cri=pop->det;

	xtest=(double)(pop->ndim);
	xdim=xtest;

	for(iprot=0;iprot<nprot;iprot++)
	{


		deja=0;
		for(j=0;j<pop->np;j++)
		{
			if (iprot==pop->num[j]) deja=1;
		}
		if(fabs(deja)<EPSILON)
		{
			xmul=matrace(iprot,allprot,pop);
			if(xmul>=xtest)
			{
				xtest=xmul;
				qajout=iprot;
			}
		}
	}
	if(fabs(xtest-xdim)<EPSILON)
	{
		ifin=1;
	}
	else
	{
		rcalc=(xtest-xdim)/(xdim*(xtest-1));

		PROTOC_alloc(&pop->pind[pop->np],allprot[qajout].ntps,allprot[qajout].ndim);
		PROTOC_copy(&allprot[qajout],&pop->pind[pop->np]);
		pop->num[pop->np]=qajout;
		pop->freq[pop->np]=rcalc;


		for(j=0;j<pop->np;j++) pop->freq[j]=pop->freq[j]*(1-rcalc);
		pop->np++;
	}

	cri=lik(pop);
	return ifin;
}

int takeout_k(POPROT *pop,PROTOC *allprot,int *nnul)
{
	int ir=-1,j;
	double xmul;
	xmul=lik(pop); /*update Mf-1 */
	for(j=0;j<pop->np;j++)
	{
		xmul=0;
		if(pop->freq[j]<=FREQMIN)
		{
			xmul=matrace(pop->num[j],allprot,pop);
			if(xmul>(double)pop->ndim)
			{
				ir=j;
				*nnul=*nnul-1;
				return ir;
			}
		}
	}
	return ir;
}

int project_grad(POPROT *pop, PROTOC *allprot, double *gal,int ir,double
		*vmgal,int nnul)
{
/* Computes the projection of the gradient of ln(V)=ln(det(H(pop))) on the
surface sum(frequencies)=1 and freq[j]=0 for all j such as pop->freq[j]<FREQMIN
gal[j] is the jth component of the projected gradient (the direction)
gal[j]=0 if pop->freq[j]<FREQMIN and j<>ir
ir is -1 or the index removed from the active set at the previous step
vmgal is the largest abs(gal[j])
returns in, the last index j such as gal[j]<0
*/
	int j,in=-1;
	double sg,sgal;

	sg=lik(pop); /* Check that Mf-1 has been computed */
	sg=0;
	for(j=0;j<pop->np;j++)
	{
		gal[j]=0;
		if((pop->freq[j]>=FREQMIN) | (j==ir))
			gal[j]=matrace(pop->num[j],allprot,pop);
		sg=sg+gal[j];
	}
	sgal=0;*vmgal=0;
	for(j=0;j<pop->np;j++)
	{
		if((pop->freq[j]>=FREQMIN) | (j==ir))
		{
			gal[j]=gal[j]-sg/(double)(pop->np-nnul);
			if(fabs(gal[j])>*vmgal) *vmgal=(double)fabs(gal[j]);
			if(gal[j]<0) in=j;
			sgal=sgal+gal[j];
		}
	}
	return in;
}


int optim_lambda(POPROT *pop, double *gal, double *alkeep, double *crit,
	double dmax, double crit2, double vmgal)
{
/* dmax is too large a move along the direction
=> move along the direction by dmax/2**k until
-the move is too small : no new frequencies have been found (return 1)
-a better likelihood is found => update pop with the new frequencies
	-if the criteria has changed by more than FTOL, return 0
	-else return 1; the frequencies correspond to the last (smallest) move
*/
	int j;
	double ro=1,crit1;
	do
	{
		ro=ro*0.5;
		for(j=0;j<pop->np;j++) pop->freq[j]=alkeep[j]+ro*dmax*gal[j];
		crit1=lik(pop); /* Updates Mf-1 for new frequencies */
		if(crit1>*crit)
		{
			for(j=0;j<pop->np;j++) alkeep[j]=pop->freq[j];
			*crit=crit1;
			if(fabs((crit2-*crit)/crit2)>FTOL) {return 0;}
			else {return 1;}
		}
	} while((dmax*ro*vmgal)>1e-4);
	for(j=0;j<pop->np;j++) pop->freq[j]=alkeep[j];
	return 1;
}



int doptimal(POPROT *pop,PROTOC *allprot)
{
	int nnul=0, ir=-1,in=-1,nit=0;
	int j,imax,iopt;
	double crit,crit1,crit2,vmgal,dmax;
	double *gal,*alkeep;
	double sal,sal1;

	gal=(double *)calloc(pop->np,sizeof(double));
	alkeep=(double *)calloc(pop->np,sizeof(double));
	crit=lik(pop); /*Calcul de Mf-1 */

	for(nit=0;nit<500;nit++)
	{
/* alkeep stores the initial frequencies of the elementary protocols
*/
		for(j=0;j<pop->np;j++)
			alkeep[j]=pop->freq[j];
		crit2=crit;
		if(ir==(-1)) /* First time through */
		{
			nnul=0; /* Computing the number of nul frequencies */
			for(j=0;j<pop->np;j++)
			{
				if(pop->freq[j]<FREQMIN) nnul++;
			}
		}
/* Compute the projected gradient (direction)*/
		in=project_grad(pop,allprot,gal,ir,&vmgal,nnul);
		if((in<0) | (gal[in]==0))
		{
			free(gal);
			free(alkeep);
			return nnul;
		}
/* Compute the optimal change along the gradient dmax (lambda)*/
		dmax=-pop->freq[in]/gal[in];
		imax=in;
		if((ir!=(-1)) & (gal[ir]<=0))
		{
			free(gal);
			free(alkeep);
			return nnul;
		}
		ir=-1;
		for(j=0;j<pop->np;j++)
		{
			if((gal[j]<0) & (fabs(pop->freq[j]/gal[j])<dmax))
			{
				dmax=-pop->freq[j]/gal[j];
				imax=j;
			}
		}
/* Updates the frequencies as beta*(t,j)=beta(t,j)+dmax*gal(j)
Compute the likelihood for the updated vector of frequencies
*/
		sal=0;
		for(j=0;j<pop->np;j++)
		{
			pop->freq[j]=pop->freq[j]+dmax*gal[j];
			sal=sal+pop->freq[j];
		}
		sal1=sal-pop->freq[imax];
		pop->freq[imax]=0;
		crit1=lik(pop);
/* If better likelihood, update alkeep (pop->freq has been updated already)
*/
		if(crit1>crit)
		{
			for(j=0;j<pop->np;j++) alkeep[j]=pop->freq[j];
			crit=crit1;
			nnul++;
		}
		else
		{
			for(j=0;j<pop->np;j++) pop->freq[j]=alkeep[j];
/* If not, try dmax*ro for ro=1/2**k until dmax*ro too small
*/
			iopt=optim_lambda(pop,gal,alkeep,&crit,dmax,crit2,vmgal);
			if(iopt==1)
			{
				ir=takeout_k(pop,allprot,&nnul);
/* ir=-1 if for all j, matrace(q[j]) <= ndim*(ndim+1)/2, ie optimal protocol
=> in that case exit the subroutine
*/
				if(ir==(-1))
				{
					free(gal);
					free(alkeep);
					return nnul;
				}
			}
		}
	}
	free(gal);
	free(alkeep);
	return -10;
}


void index_limit(POPROT *pop)
{
	return;
}

// ******************************************************************************************************************

int main_opt(PROTOC *allprot, POPROT *pop, IntegerVector nprot)
{
  int nit=0,ifin=0,nstop,ntest;
	double cri;

	cri=lik(pop);

	for(nit=0;nit<100;nit++)
	{

  nstop=0;
do
{
  ifin=ajout(allprot,pop,nprot[0]);
  nstop++;
} while ((cri<(-1e10))& (nstop<100));

if((nstop>99)& (cri<(-1e10)))

{
  return -10;
}
if(ifin==1) break; /* Si ifin=1, on sort de la boucle sur nit */
  ntest=doptimal(pop,allprot);
  if(ntest<0)
    return -100;
  tassement(pop);

  if(pop->np>(pop->ndim*(pop->ndim+1)/2))
  {
    index_limit(pop);
    return -1;
  }
  cri=lik(pop); /* Updates matrices */
    }
return nit;
}

// ******************************************************************************************************************

/******************************************************************************
  Fonctions calculatoires
	matrace:
	lik:determinant de hh et inverse de hh
*******************************************************************************/

double matrace(int iprot,PROTOC *prot,POPROT *pop)
{/* Computes tr(Mf(iprot)*Mf-1(poprot))
WARNING pop->finv must be computed beforehand (with a call to lik)*/
	int i,j,ij;
	double xcal=0;

	for(i=0;i<(prot->ndim);i++)
	{
		for(j=0;j<i;j++)
		{

			ij=i*(i+1)/2+j;
			xcal=xcal+2*(prot[iprot].fisher[ij])*(pop->finv[ij]);
			}
		ij=i*(i+3)/2;
		xcal=xcal+(prot[iprot].fisher[ij])*(pop->finv[ij]);
		}
	return xcal;
}

double lik(POPROT *pop)
{/* Function to compute the inverse of the Fisher information matrix of the
population protocol pop. Returns the determinant of the matrix, also stored in
pop->det. The Fisher  information matrix of the population protocol is stored
in pop->fisher and the inverse is stored in pop->finv
*/
	int ndim=pop->ndim;

	int ncase=(int)(ndim*(ndim+1)/2);

	int i,j,jj,ifail;
	int *indx;
	double *col;
	matrix *xa;
	double cri;

	indx=(int *)calloc(ndim,sizeof(int));
	col=(double *)calloc(ndim,sizeof(double));
	xa=matrix_create(ndim,ndim);


	for(i=0;i<ncase;i++)
	{
		pop->fisher[i]=0;
		for(j=0;j<pop->np;j++)
		{
pop->fisher[i]=pop->fisher[i]+pop->freq[j]*pop->pind[j].fisher[i];
		}
	}
	jj=0;
	for(i=0;i<ndim;i++)
	{
		for(j=0;j<=i;j++)
		{
			xa->m[i][j]=pop->fisher[jj];
			xa->m[j][i]=pop->fisher[jj];

			jj++;
		}
	}

	ifail=ludcmp(xa->m,ndim,indx,&cri);

	if(ifail==1) return CRI_MAX;
	for(i=0;i<ndim;i++) cri=cri*xa->m[i][i];
	pop->det=cri;
	for(i=0;i<ndim;i++)
	{
		for(j=0;j<ndim;j++) col[j]=0.0;
		col[i]=1.0;
		lubksb(xa->m,ndim,indx,col);
		for(j=0;j<ndim;j++)
		{
			jj=i*(i+1)/2+j;
			pop->finv[jj]=col[j]; /*=xb[j][i] using another matrix*/
			}
		}
	/* desallocation */
	matrix_destroy(xa);
	free(indx);
	return cri;
}

void lubksb(double **a, int n, int *indx, double b[])
{
	int i,ii=-1,ip,j;
	double sum;

	for (i=0;i<n;i++) {
		ip=indx[i];
		sum=b[ip];
		b[ip]=b[i];
		if (ii>=0)
			for (j=ii;j<=i-1;j++) sum -= a[i][j]*b[j];
		else if (sum) ii=i;
		b[i]=sum;
	}
	for (i=n-1;i>=0;i--) {
		sum=b[i];
		for (j=i+1;j<n;j++) sum -= a[i][j]*b[j];
		b[i]=sum/a[i][i];
	}
}

int ludcmp(double **a, int n,int *indx, double *d)
{
	int i,imax,j,k;
	double big,dum,sum,temp;
	double *vv;

	vv=(double *)calloc(n,sizeof(double));
	*d=1.0;
	for (i=0;i<n;i++) {
		big=0.0;
		for (j=0;j<n;j++)

			if ((temp=fabs(a[i][j])) > big) big=temp;

		if (big == 0.0) {

			return 1;}
		vv[i]=1.0/big;
	}
	for (j=0;j<n;j++) {
		for (i=0;i<j;i++) {
			sum=a[i][j];
			for (k=0;k<i;k++) sum -= a[i][k]*a[k][j];
			a[i][j]=sum;
		}
		big=0.0;
		for (i=j;i<n;i++) {
			sum=a[i][j];
			for (k=0;k<j;k++)
				sum -= a[i][k]*a[k][j];
			a[i][j]=sum;
			if ( (dum=vv[i]*fabs(sum)) >= big) {
				big=dum;
				imax=i;
			}
		}
		if (j != imax) {
			for (k=0;k<n;k++) {
				dum=a[imax][k];
				a[imax][k]=a[j][k];
				a[j][k]=dum;
			}
			*d = -(*d);
			vv[imax]=vv[j];
		}
		indx[j]=imax;
		if (a[j][j] == 0.0) a[j][j]=TINY;
		if (j != (n-1)) {
			dum=1.0/(a[j][j]);
			for (i=j+1;i<n;i++) a[i][j] *= dum;
		}
	}
	free(vv);
	return 0;
}

/* Random number generator */
double randu(double x)
{	double xrand;
	xrand=rand();
	return xrand;
}
double gauss1(long *idum)
{
/* 	float ran1(long *idum);
*/	static int iset=0;
	static float gset;
	float fac,rsq,v1,v2;

	if  (iset == 0) {
		do {
			v1=2.0*ran1(idum)-1.0;
			v2=2.0*ran1(idum)-1.0;
			rsq=v1*v1+v2*v2;
		} while (rsq >= 1.0 || rsq == 0.0);
		fac=sqrt(-2.0*log(rsq)/rsq);
		gset=v1*fac;
		iset=1;
		return v2*fac;
	} else {
		iset=0;
		return (double)gset;
	}
}

float ran1(long *idum)
{
	int j;
	long k;
	static long iy=0;
	static long iv[NTAB];
	float temp;

	if (*idum <= 0 || !iy) {
		if (-(*idum) < 1) *idum=1;
		else *idum = -(*idum);
		for (j=NTAB+7;j>=0;j--) {
			k=(*idum)/IQ;
			*idum=IA*(*idum-k*IQ)-IR*k;
			if (*idum < 0) *idum += IM;
			if (j < NTAB) iv[j] = *idum;
		}
		iy=iv[0];
	}
	k=(*idum)/IQ;
	*idum=IA*(*idum-k*IQ)-IR*k;
	if (*idum < 0) *idum += IM;
	j=iy/NDIV;
	iy=iv[j];
	iv[j] = *idum;
	if ((temp=AM*iy) > RNMX) return RNMX;
	else return temp;
}

/******************************************************************************
 FedorovInit_R
*******************************************************************************/
// [[Rcpp::export]]

List FedorovWynnAlgorithm_Rcpp( List protocols,
                                IntegerVector ndimen,
                                IntegerVector nbprot,
                                IntegerVector numprot,
                                NumericVector freq,
                                IntegerVector nbdata,
                                NumericVector vectps,
                                NumericVector fisher,
                                IntegerVector error,
                                IntegerVector protdep,
                                NumericVector freqdep)
{

IntegerVector nb_protocols = as<IntegerVector>(protocols[0]);
IntegerVector nb_times = as<IntegerVector>(protocols[1]);
IntegerVector nb_dimensions = as<IntegerVector>(protocols[2]);
IntegerVector total_cost = as<IntegerVector>(ndimen);
NumericMatrix samplingTimes = as<NumericMatrix >(protocols[4]);
NumericMatrix fisher_matrices = as<NumericMatrix>(protocols[5]);


// ***************************************************************************************

// ***************
// init parameters
// ***************

IntegerVector nprot = as<IntegerVector>(nb_protocols);
IntegerVector ndim = as<IntegerVector>(nb_dimensions);
int Ntot = total_cost[2];

// matrix for the optimal sampling times
NumericMatrix optimal_sampling_times(nprot[0],nb_times[0]);

int i,j,ij,ik,iprot,icas;

// *******************
//protocols
// *******************

// Vector of individual protocols
PROTOC *allprot;
allprot = (PROTOC *)calloc(nprot[0], sizeof(PROTOC));

// Population protocol
POPROT *pop;

// *********************************************
// sampling times
// allprot[i].tps = sampling time i
// allprot[i].tps[j] = element j of sampling time i
// *********************************************
// fisher matrices
// allprot[iprot].fisher[k]
// *********************************************

for(iprot=0;iprot<nprot[0];iprot++){

  PROTOC_alloc(&allprot[iprot],nb_times[0],ndim[0]);

  NumericVector row_matrix_sampling_times = samplingTimes.row(iprot);

  NumericVector fisher_matrix = fisher_matrices.row(iprot);

  for ( j=0; j< allprot[iprot].ntps;j++){
  allprot[iprot].tps[j] = row_matrix_sampling_times[j];
  }

  icas=0;

  for (ij=0;ij<ndim[0];ij++) {
    for (ik=0;ik<=ij;ik++) {
      allprot[iprot].fisher[icas]=fisher_matrix[icas]*Ntot/nb_times[0];
      icas++;
    }
  }
}

pop = initprot(allprot, protdep, freqdep);

// *********************************************
// optimisation des protocoles
// nok
// *********************************************

int nok = 0;
double sumf = 0;

nok = main_opt(allprot,pop,nprot);

  if(nok>=0) {

    sumf=0;

    for(i=0;i<pop->np;i++) {

      numprot[i]=pop->num[i]+1;
      nbdata[i]=pop->pind[i].ntps;

      freq[i]=pop->freq[i]*Ntot/(nb_times[0]);

      sumf=sumf+freq[i];

      freqdep[i]=pop->freq[i];
    }

    for(i=0;i<pop->np;i++) {
      freq[i]=freq[i]/sumf;

      for(j=0;j<pop->pind[i].ntps;j++) {
        vectps[j]=pop->pind[i].tps[j];

optimal_sampling_times(i,j) = pop->pind[i].tps[j];

      }
    }
    for(i=0;i<(pop->ndim*(pop->ndim+1)/2);i++) {
      fisher[i]=pop->fisher[i];
    }
  }

  return Rcpp::List::create(
    Rcpp::Named("freq") = freq,
    Rcpp::Named("optimal_sampling_times") = optimal_sampling_times,
    Rcpp::Named("fisher") = fisher,
    Rcpp::Named("numprot") = numprot);


} // end FedorovInit_R
'
FedorovWynnAlgorithm_Rcpp = inline::cxxfunction( signature( protocols_input = "list",
                                                            ndimen_input = "integer",
                                                            nbprot_input = "integer",
                                                            numprot_input = "integer",
                                                            freq_input = "numeric",
                                                            nbdata_input = "integer",
                                                            vectps_input = "numeric",
                                                            fisher_input = "numeric",
                                                            nok_input = "integer",
                                                            protdep_input = "integer",
                                                            freqdep_input = "numeric"),
                                                 plugin = "Rcpp",
                                                 incl = incltxtFedorovWynnAlgorithm,
                                                 body = '
          List protocols = Rcpp::as<List>(protocols_input);
          IntegerVector ndimen  = Rcpp::as<IntegerVector>(ndimen_input);
          IntegerVector nbprot  = Rcpp::as<IntegerVector>(nbprot_input);
          IntegerVector numprot = Rcpp::as<IntegerVector>(numprot_input);
          NumericVector freq = Rcpp::as<NumericVector>(freq_input);
          IntegerVector nbdata = Rcpp::as<IntegerVector>(nbdata_input);
          NumericVector vectps = Rcpp::as<NumericVector>(vectps_input);
          NumericVector fisher = Rcpp::as<NumericVector>(fisher_input);
          IntegerVector nok = Rcpp::as<IntegerVector>(nok_input);
          IntegerVector protdep = Rcpp::as<IntegerVector>(protdep_input);
          NumericVector freqdep = Rcpp::as<NumericVector>(freqdep_input);

          return Rcpp::wrap( FedorovWynnAlgorithm_Rcpp(  protocols, ndimen, nbprot, numprot, freq, nbdata, vectps, fisher, nok, protdep, freqdep ) );')

output = FedorovWynnAlgorithm_Rcpp( protocols_input,  ndimen_input, nbprot_input,
                                    numprot_input, freq_input, nbdata_input,
                                    vectps_input, fisher_input, nok_input,
                                    protdep_input, freqdep_input )

return( output )

}

# ==============================================================================
#' @rdname optimizeDesign
#' @name optimizeDesign
#' @export
# ==============================================================================

method( optimizeDesign, list( .Optimization_S7, FedorovWynnAlgorithm ) ) = function( optimizationObject, optimizationAlgorithm ) {

  # parameters of the optimization algorithm
  optimizerParameters = prop( optimizationObject, "optimizerParameters")
  initialSamplings = optimizerParameters$elementaryProtocols
  totalNumberOfIndividuals = optimizerParameters$numberOfSubjects
  proportionsOfSubjects = optimizerParameters$proportionsOfSubjects
  initialElementaryProtocols = unlist( optimizerParameters$elementaryProtocols )
  totalCost = sum( lengths( initialSamplings ) * totalNumberOfIndividuals )

  # get the design
  designs = prop( optimizationObject, "designs" )
  design = pluck( designs, 1 )
  optimalDesign = design
  designName = prop( design, "name" )

  # generate the Fims from administration and sampling times constraints
  fimsFromConstraints = generateFimsFromConstraints( optimizationObject )

  # get samplings and FIMs
  samplingsForFedorovWynn = reduce( fimsFromConstraints$samplingsForFedorovWynnAlgo[[designName]], rbind )
  fisherMatrices = reduce( fimsFromConstraints$listFimsAlgoFW[[designName]], rbind )

  # list of arms
  listArms = fimsFromConstraints$listArms[[designName]]

  # elementaryProtocols
  elementaryProtocolsFW = list()
  elementaryProtocolsFW$numberOfprotocols = nrow( samplingsForFedorovWynn )
  elementaryProtocolsFW$numberOfTimes = ncol( samplingsForFedorovWynn )
  elementaryProtocolsFW$nbOfDimensions = fimsFromConstraints$dimFim
  elementaryProtocolsFW$totalCost = totalCost
  elementaryProtocolsFW$samplingTimes = samplingsForFedorovWynn
  elementaryProtocolsFW$fisherMatrices = fisherMatrices

  ndim = elementaryProtocolsFW$numberOfprotocols
  ndimen = c( elementaryProtocolsFW$numberOfprotocols, elementaryProtocolsFW$nbOfDimensions, elementaryProtocolsFW$totalCost )
  npInit = elementaryProtocolsFW$numberOfprotocols
  numprot = rep(0,ndim*2)
  freq = rep(0,ndim*2)
  nbdata = rep(0,ndim*2)
  vectps = rep(0,length(numprot))
  fisher = rep(0,ndim*(ndim + 1)/2)
  nok = 0

  # indices for initial oversampling in matrix of initialElementaryProtocols
  samplingTimes = elementaryProtocolsFW$samplingTimes
  indexElementaryProtocols = rowSums(samplingTimes == initialElementaryProtocols[col(samplingTimes)]) == ncol(samplingTimes)
  indexElementaryProtocols = which( indexElementaryProtocols == TRUE )
  numberOfElementaryProtocol = length( indexElementaryProtocols )

  # initial protocols, number and indices
  zeprot = rep(0,ndim*2)
  zeprot = c( numberOfElementaryProtocol, indexElementaryProtocols )
  # initials frequencies
  zefreq = rep(0,ndim*2)
  zefreq[1:length(proportionsOfSubjects)] = proportionsOfSubjects

  # run the FedorovWynn algorithm
  output = FedorovWynnAlgorithm_Rcpp( elementaryProtocolsFW, ndimen, npInit, numprot, freq, nbdata, vectps, fisher, nok, zeprot, zefreq )

  # optimalSamplingTimes : remove rows of 0 and convert matrix to a list of vector
  optimalSamplingTimes = output$optimal_sampling_times
  indexOptimalSamplingTimes = which(rowSums( optimalSamplingTimes ) > 0 )

  # check if FW has converged
  if ( length( indexOptimalSamplingTimes ) == 0 )
  {
    message( " ==================================================================================================== ")
    message( " The algorithm has not converged " )
    message( " ==================================================================================================== ")
    stop()
  }

  # optimal frequencies
  optimalFrequencies = output$freq[output$freq>0]

  # get the optimal arms and rename the list
  indexOptimalSamplingTime = output$numprot
  indexOptimalSamplingTime = indexOptimalSamplingTime[indexOptimalSamplingTime > 0]
  listArms = listArms[indexOptimalSamplingTime]

  # number of individuals and freq
  numberOfIndividuals = optimizerParameters$numberOfSubjects * optimalFrequencies

  # set the results
  prop( optimizationAlgorithm, "FedorovWynnAlgorithmOutputs" ) = list( listArms = listArms, optimalFrequencies = optimalFrequencies, numberOfIndividuals = numberOfIndividuals )

  # set the optimal arms to the optimal design
  fim =  prop( optimizationObject, "fim" )
  optimalArms = setOptimalArms( fim, optimizationAlgorithm )

  # set optimal arms
  prop( optimalDesign, "arms" ) = map( optimalArms, ~.x$arm )

  # evaluate the optimal design
  evaluationOptimalDesign = Evaluation( name = "internalFimEvaluation",
                                        modelEquations = prop( optimizationObject, "modelEquations" ),
                                        modelParameters = prop( optimizationObject, "modelParameters" ),
                                        modelError = prop( optimizationObject, "modelError" ),
                                        designs = list( optimalDesign ),
                                        fimType = prop( optimizationObject, "fimType" ),
                                        outputs = prop( optimizationObject, "outputs" ),
                                        odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

  evaluationOptimalDesign = run( evaluationOptimalDesign )

  # evaluate the initial design
  evaluationInitialDesign = Evaluation( name = "internalFimEvaluation",
                                        modelEquations = prop( optimizationObject, "modelEquations" ),
                                        modelParameters = prop( optimizationObject, "modelParameters" ),
                                        modelError = prop( optimizationObject, "modelError" ),
                                        designs = list( design ),
                                        fimType = prop( optimizationObject, "fimType" ),
                                        outputs = prop( optimizationObject, "outputs" ),
                                        odeSolverParameters = prop( optimizationObject, "odeSolverParameters" ) )

  evaluationInitialDesign = run( evaluationInitialDesign )


  # set the results in evaluation
  prop( optimizationObject, "optimisationDesign" ) = list( evaluationInitialDesign = evaluationInitialDesign, evaluationOptimalDesign = evaluationOptimalDesign )
  prop( optimizationObject, "optimisationAlgorithmOutputs" ) = list( "optimizationAlgorithm" = optimizationAlgorithm, "optimalArms" = optimalArms, "frequencies" = optimalFrequencies )

  return( optimizationObject )

}

# ==============================================================================
#' @title plotFrequenciesFedorovWynnAlgorithm for the FedorovWynnAlgorithm
#' @name plotFrequenciesFedorovWynnAlgorithm
#' @description
#' Generates a horizontal bar chart representing the optimal frequencies of the
#' arms selected by the Fedorov-Wynn algorithm.
#' @param optimization An object of class \code{Optimization}.
#' @param optimizationAlgorithm An object of class \code{FedorovWynnAlgorithm}.
#' @return A \code{ggplot} object showing the frequency distribution.
#' @template copyright
#' @export
# ==============================================================================

method( plotFrequenciesFedorovWynnAlgorithm, list( .Optimization_S7, FedorovWynnAlgorithm ) ) = function( optimization, optimizationAlgorithm )
{
  optimisationAlgorithmOutputs = prop( optimization, "optimisationAlgorithmOutputs" )
  frequencies = optimisationAlgorithmOutputs$frequencies
  optimalArms = optimisationAlgorithmOutputs$optimalArms

  optimalArmsName = map( optimalArms, ~ prop(.x$arm,"name" ) ) %>% unlist()
  optimalArms = data.frame( optimalArmsName, frequencies )

  frequenciesPlot = ggplot(optimalArms, aes(x = reorder(optimalArmsName, frequencies), y = frequencies)) +
    geom_bar(stat = "identity", fill = "gray50") +
    scale_y_continuous(limits = c(0, 1),breaks = seq(0, 1, by = 0.1),minor_breaks = seq(0, 1, by = 0.05),expand = c(0, 0)  ) +
    scale_x_discrete(expand = c(0, 0)) +
    labs(  x = "Arm",  y = "Frequency" ) +
    coord_flip() +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold"),
      axis.title.x = element_text(color = "black", margin = margin(t = 10)),
      axis.title.y = element_text(color = "black", margin = margin(r = 10)),
      axis.text.x = element_text(color = "black", margin = margin(t = 5)),
      axis.text.y = element_text(color = "black", margin = margin(r = 5)),
      panel.grid.major.x = element_line(color = "gray90", linewidth = 0.5),
      panel.grid.minor.x = element_line(color = "gray95", linewidth = 0.3),
      panel.grid.major.y = element_blank(),
      panel.grid.minor.y = element_blank(),
      panel.border = element_rect(color = "gray80", fill = NA, linewidth = 0.5),
      plot.margin = margin(10, 10, 10, 10) )
  return( frequenciesPlot )
}

# ==============================================================================
#' @rdname constraintsTableForReport
#' @name constraintsTableForReport
#' @export
# ==============================================================================

method( constraintsTableForReport, FedorovWynnAlgorithm ) = function( optimizationAlgorithm, arms  )
{
  armsConstraints = map( pluck( arms, 1 ) , ~ getArmConstraints( .x, optimizationAlgorithm ) )
  armsConstraints = map_dfr( pluck( armsConstraints, 1), ~ as.data.frame(.x, stringsAsFactors = FALSE ) )
  colnames( armsConstraints ) = c( "Arms name" , "Number of subjects", "Outcome", "Initial samplings", "Fixed times", "Number of samplings optimisable","Dose constraints" )
  armsConstraintsTable = kbl( armsConstraints, align = c( "l","c","c","c","c","c","c") ) %>%
    kable_styling( bootstrap_options = c( "hover" ), full_width = FALSE, position = "center", font_size = 13 )
  return( armsConstraintsTable )
}
