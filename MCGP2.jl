#The presented algorithm is made using the article titled "Descent Perry conjugate gradient methods for systems of monotone nonlinear equations". Such an algorithm is done using the given second descent direction.  

#####

function algorithm2(F, x0)
    iter = 0
    x = x0
    F_km1 = NaN
    x_km1 = NaN
    d = NaN
    while true
        Fx = F(x)
        norm_Fx = norm(Fx,2)

        println("iter $iter  norm_Fx $norm_Fx")
        if norm_Fx < epsilon
            return x,0
        end
       
        # Descent direction
        if iter == 0
            d = -Fx
        else
            y = Fx - F_km1
            s = x - x_km1
            f_k = merit2(x,F)
            f_km1 = merit2(x_km1,F)
            zeta = 2.0*(f_km1 - f_k)+dot(s,F_km1 + Fx)
            mu = s
            w = y + xi * (max(zeta,0.0) / dot(s,mu)) * mu
            sty = dot(s,y)
            t2 = (1 + (q_star * norm(y,2)^2 / sty - r_star * sty / norm(s,2)^2))
            dtw = dot(d,w)
            d = -Fx + (dot(w-t2*s,Fx) / dtw) * d    # dk
        end

        # Linesearch
        alpha = linesearch2(x,d,F)

        z = x + alpha * d

        F_z = F(z)
        norm_F_z = norm(F_z,2)

        if norm_F_z < epsilon
            return z,2
        end

        x_km1 = x
        
        x = x - (dot(F_z,x-z) / (norm_F_z)^2) * F_z  #Projection 

        F_km1 = Fx

        iter += 1
        if iter > maxiter
            return x,1
        end
        
    end

end

# Linesearch
function linesearch2(x,d,F)

    m = 0
    snorm_d2 = sigma * norm(d,2)^2
    while true
        alpha = beta^m
        if alpha < 1.e-5
            return  1.e-5
        end
        #println("alpha = $alpha")
        q = x + alpha * d
        F_q = F(q)
        stptest = dot(F_q,d) + alpha * snorm_d2 > 0.0
        if ~stptest
            return alpha
        end
        m += 1
    end


end

function merit2(x,F)

    return 0.5 * norm(F(x))^2

end