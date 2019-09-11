mutable struct HistoryODEIntegrator{algType,IIP,uType,tType,tdirType,ksEltype,SolType,CacheType} <: AbstractODEIntegrator{algType,IIP,uType,tType}
  sol::SolType
  u::uType
  k::ksEltype
  t::tType
  dt::tType
  uprev::uType
  tprev::tType
  alg::algType
  dtcache::tType
  tdir::tdirType
  saveiter::Int
  saveiter_dense::Int
  cache::CacheType
end

mutable struct DDEIntegrator{algType,IIP,uType,tType,P,eigenType,tTypeNoUnits,tdirType,
                             ksEltype,SolType,F,CacheType,IType,FP,O,dAbsType,dRelType,H,
                             FSALType,EventErrorType,CallbackCacheType} <: AbstractDDEIntegrator{algType,IIP,uType,tType}
    sol::SolType
    u::uType
    k::ksEltype
    t::tType
    dt::tType
    f::F
    p::P
    uprev::uType
    uprev2::uType
    tprev::tType
    prev_idx::Int
    prev2_idx::Int
    fpsolver::FP
    order_discontinuity_t0::Int
    tracked_discontinuities::Vector{Discontinuity{tType}}
    discontinuity_interp_points::Int
    discontinuity_abstol::dAbsType
    discontinuity_reltol::dRelType
    alg::algType
    dtcache::tType
    dtchangeable::Bool
    dtpropose::tType
    tdir::tdirType
    eigen_est::eigenType
    EEst::tTypeNoUnits
    qold::tTypeNoUnits
    q11::tTypeNoUnits
    erracc::tTypeNoUnits
    dtacc::tType
    success_iter::Int
    iter::Int
    saveiter::Int
    saveiter_dense::Int
    cache::CacheType
    callback_cache::CallbackCacheType
    kshortsize::Int
    force_stepfail::Bool
    last_stepfail::Bool
    just_hit_tstop::Bool
    event_last_time::Int
    vector_event_last_time::Int
    last_event_error::EventErrorType
    accept_step::Bool
    isout::Bool
    reeval_fsal::Bool
    u_modified::Bool
    opts::O
    destats::DDEStats
    history::H
    integrator::IType
    fsalfirst::FSALType
    fsallast::FSALType

    # incomplete initialization without fsalfirst and fsallast
    function DDEIntegrator{algType,IIP,uType,tType,P,eigenType,tTypeNoUnits,
                           tdirType,ksEltype,SolType,F,CacheType,IType,FP,
                           O,dAbsType,dRelType,H,FSALType,EventErrorType,
                           CallbackCacheType}(
                               sol,u,k,t,dt,f,p,uprev,uprev2,tprev,prev_idx,prev2_idx,
                               fpsolver,order_discontinuity_t0,tracked_discontinuities,
                               discontinuity_interp_points,discontinuity_abstol,discontinuity_reltol,
                               alg,dtcache,dtchangeable,dtpropose,tdir,eigen_est,EEst,qold,
                               q11,erracc,dtacc,success_iter,iter,saveiter,saveiter_dense,
                               cache,callback_cache,kshortsize,force_stepfail,last_stepfail,
                               just_hit_tstop,event_last_time,vector_event_last_time,last_event_error,
                               accept_step,isout,reeval_fsal,u_modified,opts,destats,
                               history,integrator) where
      {algType,IIP,uType,tType,P,eigenType,tTypeNoUnits,tdirType,ksEltype,SolType,F,
       CacheType,IType,FP,O,dAbsType,dRelType,H,FSALType,EventErrorType,CallbackCacheType}

      new{algType,IIP,uType,tType,P,eigenType,tTypeNoUnits,tdirType,ksEltype,SolType,F,
          CacheType,IType,FP,O,dAbsType,dRelType,H,FSALType,EventErrorType,
          CallbackCacheType}(
            sol,u,k,t,dt,f,p,uprev,uprev2,tprev,prev_idx,prev2_idx,fpsolver,
            order_discontinuity_t0,tracked_discontinuities,discontinuity_interp_points,
            discontinuity_abstol,discontinuity_reltol,alg,dtcache,dtchangeable,dtpropose,tdir,
            eigen_est,EEst,qold,q11,erracc,dtacc,success_iter,iter,saveiter,saveiter_dense,
            cache,callback_cache,kshortsize,force_stepfail,last_stepfail,just_hit_tstop,
            event_last_time,vector_event_last_time,last_event_error,accept_step,isout,
            reeval_fsal,u_modified,opts,destats,history,integrator)
    end
end

function (integrator::DDEIntegrator)(t, deriv::Type=Val{0}; idxs=nothing)
    OrdinaryDiffEq.current_interpolant(t, integrator, idxs, deriv)
end

function (integrator::DDEIntegrator)(val::AbstractArray, t::Union{Number,AbstractArray},
                                     deriv::Type=Val{0}; idxs=nothing)
    OrdinaryDiffEq.current_interpolant!(val, t, integrator, idxs, deriv)
end
