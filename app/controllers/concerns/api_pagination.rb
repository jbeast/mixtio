# Provide a with_pagination method, which adds links for first, last, next,
# and prev, into the Link header field where necessary
#
# RFC5988 http://tools.ietf.org/html/rfc5988#page-6

module ApiPagination

  extend ActiveSupport::Concern

  def with_pagination(collection)
    headers["Link"] = pagination_links(collection)
    yield(collection)
  end

protected

  def pagination_links(collection)
    page(collection).map do |link, page_number|
      build_link(link, page_number)
    end.join(", ")
  end

  # Builds a link of the form:
  # <http://www.example.com/api/v1/consumables?page=5>; rel="last"
  def build_link(link, page_number)
    query_parameters = request.query_parameters
    new_request_hash = query_parameters.merge(:page => page_number)
    "<#{full_path}?#{new_request_hash.to_param}>; rel=\"#{link}\""
  end

  def full_path
    request.base_url + request.path
  end

  def page(collection)
    page = {}
    page[:first] = 1 if collection.total_pages > 1 && !collection.first_page?
    page[:last]  = collection.total_pages if collection.total_pages > 1 && !collection.last_page?
    page[:next]  = collection.current_page + 1 unless collection.last_page?
    page[:prev]  = collection.current_page - 1 unless collection.first_page?
    page
  end

end