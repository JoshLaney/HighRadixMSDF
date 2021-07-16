classdef Adder
    properties
        radix
        width
        color
        marker
        err
        abs
        mr
        bits
        data_points
    end
    methods
        function obj = Adder(r,w, dp, m, c)
            obj.radix = r;
            obj.width = w;
            obj.color = c;
            obj.marker = m;
            obj.data_points=dp;
            if(r>=2)
                obj.err = condition_data(obj, readmatrix(sprintf('r%d_w%d/r%d_w%d_err.csv',r,w,r,w)));
        
                obj.abs = condition_data(obj, readmatrix(sprintf('r%d_w%d/r%d_w%d_abs_err.csv',r,w,r,w)));
                obj.mr = condition_data(obj, readmatrix(sprintf('r%d_w%d/r%d_w%d_mr_err.csv',r,w,r,w)));
                obj.bits = normilize_bits(obj, condition_data(obj, readmatrix(sprintf('r%d_w%d/r%d_w%d_bf_loc.csv',r,w,r,w))));
            else
                obj.err = condition_data(obj, readmatrix(sprintf('control_w%d/control_w%d_err.csv',w,w)));
                obj.abs = condition_data(obj, readmatrix(sprintf('control_w%d/control_w%d_abs_err.csv',w,w)));
                obj.mr = condition_data(obj, readmatrix(sprintf('control_w%d/control_w%d_mr_err.csv',w,w)));
                obj.bits = normilize_bits(obj, condition_data(obj, readmatrix(sprintf('control_w%d/control_w%d_bf_loc.csv',w,w))));
            end
        end
        
        function plot(obj, data)
            [~,n] = size(data);
            for i = 2:n
                nexttile(i-1);
                plot(data(:,1),data(:,i),obj.marker,'Color',obj.color);
                hold on
            end
        end
        
        function avg=condition_data(obj,x)
            [~,idx]=sort(x(:,1));
            sorted=x(idx,:);
            [~,n] = size(sorted);
            [C,~,idx] = unique(sorted(:,1),'stable');
            for i = 3:(min(n,5))
                sorted(:,i)=monotonic_data(obj,sorted(:,i));
            end
            [m,~] = size(C);
            avg = zeros(m,n);
            avg(:,1)=C;
            for i = 2:n
                val = accumarray(idx,sorted(:,i),[],@mean);
                avg(:,i) = val;
            end
            avg(:,2) = monotonic_data(obj,avg(:,2));
            
            avg(:,n) = monotonic_data(obj,avg(:,n));
        end

        function data=monotonic_data(obj, x)
            data = zeros(size(x));
            max=x(1);
            for i = 1:size(x)
                if(abs(max)<abs(x(i))) 
                    max=x(i);
                end
                data(i)=max;
            end
        end
        
        function normd = normilize_bits(obj, x)
            [~,n] = size(x);
            normd = zeros(size(x));
            n_bits = (obj.width+1)*(log2(obj.radix)+1);
            normd(:,1)=x(:,1);
            for i = 2:n
                normd(:,i)=x(:,i)./n_bits;
            end
            normd(:,n-1)=x(:,n-1)./(n_bits*obj.data_points);
        end
    end
end