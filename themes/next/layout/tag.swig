{% extends '_layout.swig' %}
{% import '_macro/post-collapse.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}

{% block title %}{{ __('title.tag') }}: {{ page.tag }} | {{ config.title }}{% endblock %}

{% block content %}

  {#################}
  {### TAG BLOCK ###}
  {#################}
  <div class="post-block tag">

    <div id="posts" class="posts-collapse">
      <div class="collection-title">
        <{% if theme.seo %}h2{% else %}h1{% endif %}>{#
        #}{{ page.tag }}{#
        #}<small>{{  __('title.tag')  }}</small>
        </{% if theme.seo %}h2{% else %}h1{% endif %}>
      </div>

      {% for post in page.posts %}
        {# Show year #}
        {% set year %}
        {% set post.year = date(post.date, 'YYYY') %}
  
        {% if post.year !== year %}
          {% set year = post.year %}
          <div class="collection-title">
            <h2 class="archive-year motion-element" id="archive-year-{{ year }}">{{ year }}</h2>
          </div>
        {% endif %}
        {# endshow #}
        {{ post_template.render(post) }}

        {{ post_template.render(post) }}
      {% endfor %}
    </div>

  </div>
  {#####################}
  {### END TAG BLOCK ###}
  {#####################}

  {% include '_partials/pagination.swig' %}
{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(false) }}
{% endblock %}

{% block script_extra %}
  {% if theme.use_motion %}
    <script type="text/javascript" id="motion.page.archive">
      $('.archive-year').velocity('transition.slideLeftIn');
    </script>
  {% endif %}
{% endblock %}