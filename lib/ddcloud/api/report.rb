module DDcloud::API
    class Report < Core
        def auditlog(start_date, end_date)
            start = start_date.strftime("%Y-%m-%d")
            stop = end_date.strftime("%Y-%m-%d")
            org_endpoint "/auditlog?startDate=#{start}&endDate=#{stop}"
            get_simple
        end

        def summary_usage(start_date, end_date)
            start = start_date.strftime("%Y-%m-%d")
            stop = end_date.strftime("%Y-%m-%d")
            org_endpoint "/report/usage?startDate=#{start}&endDate=#{stop}"
            get_simple
        end

        def detailed_usage(start_date, end_date)
            start = start_date.strftime("%Y-%m-%d")
            stop = end_date.strftime("%Y-%m-%d")
            org_endpoint "/report/usageDetailed?startDate=#{start}&endDate=#{stop}"
            get_simple
        end
    end
end
