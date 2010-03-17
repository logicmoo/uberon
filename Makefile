ZFA_OBO=../gross_anatomy/animal_gross_anatomy/fish/zebrafish_anatomy.obo 
#FLY_OBO=../gross_anatomy/animal_gross_anatomy/fly/fly_anatomy.obo 
FLY_OBO=fly2.obo
PO_OBO=$(HOME)/cvs/Poc/ontology/OBO_format/po_anatomy.obo

all: adult_mouse_xp.obo po_anatomy_xp.obo fly_anatomy_xp.obo zebrafish_anatomy_xp.obo worm_anatomy_xp.obo dictyostelium_anatomy_xp.obo xenopus_anatomy_xp.obo fungal_anatomy-cellular_component-aln.txt

OBOL=obol -r ubo -r relationship -r ro_proposed -table_pred user:gross_anatomical/3 -table_pred user:gross_anatomical5/3  -table_pred classdef_parser:any_kind_of/3 -table_pred user:continuant/3 -table_pred ontol_db:subclassT/2 -table_pred user:cell/3 -table_pred user:cell5/3 -table_pred user:spatial/3 -u obol_anatomy_xp -r obol_av 

po_anatomy_xp.obo:
	$(OBOL) -u obol_anatomy_xp_sensu -r plant_anatomy obol-parse -parse_rule anatomical_continuant "belongs(ID,plant_structure)" >& $@.tmp && mv $@.tmp $@

fly_anatomy_xp.obo:
	$(OBOL) -r fly_anatomy obol-parse "belongs(ID,'fly_anatomy.ontology')" >& $@.tmp && mv $@.tmp $@

zebrafish_anatomy_xp-obol.obo:
	$(OBOL) -i zfa_extra.obo -u obol_zfa_xp -u hook_hier -r zebrafish_anatomy -i zebrafish_anatomy_xp.obo obol-parse  -minscore 1 -xp_policy newonly "belongs(ID,zebrafish_anatomy)" >& $@.tmp && mv $@.tmp $@
#	$(OBOL) -i zfa_extra.obo -u obol_zfa_xp -u hook_hier -r zebrafish_anatomy obol-parse  -minscore 2 -xp_policy newonly "belongs(ID,zebrafish_anatomy)" >& $@.tmp && mv $@.tmp $@
#	$(OBOL) -u obol_zfa_xp -u hook_hier -r zebrafish_anatomy -i zebrafish_anatomy_xp.obo obol-parse -xp_policy newonly "belongs(ID,zebrafish_anatomy)" >& $@.tmp && mv $@.tmp $@

xenopus_anatomy_xp-obol.obo:
	$(OBOL) -i zfa_extra.obo -u hook_hier -r xenopus_anatomy -i xenopus_anatomy_xp.obo  obol-parse  -minscore 1 -xp_policy newonly "belongs(ID,xenopus_anatomy)" >& $@.tmp && mv $@.tmp $@
#	$(OBOL) -r xenopus_anatomy obol-parse "belongs(ID,xenopus_anatomy)" >& $@.tmp && mv $@.tmp $@

uberon_xp.obo: uberon_edit.obo
	$(OBOL) -i $< -u obol_nif_anatomy_xp obol-parse -xp_policy newonly "belongs(ID,uberon)" >& $@.tmp && mv $@.tmp $@

uberon_xp_chebi-obol.obo: uberon_edit.obo
	$(OBOL) -r xchebi -i $< -u obol_nif_anatomy_xp -u obol_cell_xp_secretion obol-parse -xp_policy newonly "belongs(ID,uberon)" >& $@.tmp && mv $@.tmp $@

%_xp.obo:
	$(OBOL) -r $* obol-parse "belongs(ID,'$*')" >& $@.tmp && mv $@.tmp $@

TICK=../gross_anatomy/animal_gross_anatomy/tick/tick_anatomy.obo
tick_anatomy_deplural.obo:
	$(HOME)/obol/bin/go-transform-chebi.pl -i $(TICK) > $@.tmp && mv $@.tmp $@

# ignore 'Adult' prefix...
tick_anatomy_xp.obo: tick_anatomy_deplural.obo
	$(OBOL) -u ontol_manifest_synonym_from_tick_anatomy -r cell -i tick_anatomy_deplural.obo obol-parse "belongs(ID,tick_anatomy)" >& $@.tmp && mv $@.tmp $@

dictyostelium_anatomy_xp.obo:
	$(OBOL) -u obol_dicty_anatomy_xp -r dicty_anatomy obol-parse "belongs(ID,'Dictyostelium_discoideum_anatomy')" >& $@.tmp && mv $@.tmp $@

# worm...
%_anatomy_xp.obo:
#	$(OBOL) -r $*_anatomy -r $*_development -r go obol-parse -parse_rule anatomical_continuant "belongs(ID,'$*_anatomy')" >& $@.tmp && mv $@.tmp $@
	$(OBOL) -r $*_anatomy  -r go obol-parse -parse_rule anatomical_continuant "belongs(ID,'$*_anatomy')" >& $@.tmp && mv $@.tmp $@

efo_anat.obo:
	blip -r efo ontol-subset -query "subclassRT(ID,'EFO:0000635')" -to obo > $@.tmp && mv $@.tmp $@

fma_xp-obol.obo:
	obol -i fma_xp.obo -r relationship -table_pred user:anatomical_continuant/3 -table_pred user:anatomical_continuant5/3 -u obol_fma_xp -r fma_downcase obol-parse "belongs(ID,fma)" >& $@.tmp && mv $@.tmp $@

fma_xp_uberon-obol.obo:
	obol -r relationship -table_pred user:anatomical_continuant/3 -table_pred user:anatomical_continuant5/3 -u obol_fma_xp -r fma_downcase obol-parse "belongs(ID,fma)" >& $@.tmp && mv $@.tmp $@

mouse_anatomy_fixed.obo: ../gross_anatomy/animal_gross_anatomy/mouse/adult_mouse_anatomy.obo
	perl -npe 'if (/(meta\S+ bone \w+ digit)/) {s/(hand|foot)//}' $< > $@

adult_mouse_xp-obol.obo:
	$(OBOL) -i ma_extra.obo -i adult_mouse_xp.obo -r relationship -i mouse_anatomy_fixed.obo obol-parse -xp_policy newonly "belongs(ID,'adult_mouse_anatomy.gxd')" >& $@.tmp && mv $@.tmp $@

adult_mouse_xp_uberon-obol.obo:
	$(OBOL) -i ma_extra.obo -i adult_mouse_xp.obo -r uberon -r relationship -i mouse_anatomy_fixed.obo obol-parse -xp_policy newonly "belongs(ID,'adult_mouse_anatomy.gxd')" >& $@.tmp && mv $@.tmp $@

hog_xp-obol.obo:
	$(OBOL) -r hog -r relationship obol-parse -xp_policy newonly "belongs(ID,anatomical_homology_ontology)" >& $@.tmp && mv $@.tmp $@

bila_xp-obol.obo:
	$(OBOL) -r bila -r relationship obol-parse -xp_policy newonly "belongs(ID,bila)" >& $@.tmp && mv $@.tmp $@

cell_xp-obol.obo:
	$(OBOL) -i ../cell_type/cell_xp.obo -u obol_cell_xp_go -u obol_cell_xp_quality -u obol_cell_xp_secretion -r xchebi -r go -r uberon -r pato -r cell -r ro_proposed obol-parse "belongs(ID,cell)" >& $@.tmp && mv $@.tmp $@
#	$(OBOL) -i ../cell_type/cell_xp.obo -u obol_cell_xp_go -u obol_cell_xp_quality -u obol_cell_xp_secretion -r xchebi -r protein -r go -r uberon -r pato -r cell -r ro_proposed obol-parse -new_only "belongs(ID,cell)" >& $@.tmp && mv $@.tmp $@

# -- CL mappings --

zebrafish_anatomy_xp_cell.obo:
	obo-promote-dbxref-to-intersection.pl --idspace CL -d OBO_REL:part_of NCBITaxon:7955 $(ZFA_OBO) | obo-grep.pl -r intersection_of: - | obo-filter-tags.pl -t id -t intersection_of - > $@.tmp && mv $@.tmp $@

# use: NCBITaxon:33090 Viridiplantae
plant_anatomy_xp_cell.obo:
	obo-promote-dbxref-to-intersection.pl --idspace CL -d OBO_REL:part_of NCBITaxon:33090 $(PO_OBO) | obo-grep.pl -r intersection_of: - | obo-filter-tags.pl -t id -t intersection_of - > $@.tmp && mv $@.tmp $@

# use: NCBITaxon:7227 Dmel
fly_anatomy_xp_cell.obo:
	obo-promote-dbxref-to-intersection.pl --idspace CL -d OBO_REL:part_of NCBITaxon:7227 $(FLY_OBO) | obo-grep.pl -r intersection_of: - | obo-filter-tags.pl -t id -t intersection_of - > $@.tmp && mv $@.tmp $@

# -- Alignemnts --

%-cellular_component-aln.txt:
	obol ontol-align -r $* -r go -shownames -stem $* cellular_component > $@.tmp && mv $@.tmp $@

fly_anatomy-cell-aln.tbl:
	obol ontol-align -r fly_anatomy -r cell -shownames -stem fly_anatomy.ontology cell > $@.tmp && mv $@.tmp $@

plant_anatomy-cell-aln.tbl:
	obol ontol-align -r plant_anatomy -r cell -shownames -stem plant_structure cell > $@.tmp && mv $@.tmp $@

zebrafish_anatomy-teleost_anatomy-aln.tbl:
	obol ontol-align -r zebrafish_anatomy -r teleost_anatomy -shownames -stem zebrafish_anatomy teleost_anatomy > $@.tmp && mv $@.tmp $@

zfa-fma-aln.tbl:
	obol ontol-align -r zebrafish_anatomy -r fma_downcase -shownames -stem zebrafish_anatomy fma > $@.tmp && mv $@.tmp $@

uberon-%-misalign.txt: %.obo
	blip  -r uberon -i $< -u tabling -table_pred user:xp_align/6 -u query_obo findall "xp_align_nr(A,R,B,XA,XR,XB)" -label > $@.tmp && sort -u $@.tmp > $@

%-misalign.txt: %-imports.obo
	blip  -import_all -i $< -u tabling -table_pred user:xp_align/6 -u query_obo findall "xp_align_nr(A,R,B,XA,XR,XB)" -label > $@.tmp && sort -u $@.tmp > $@

# e.g. uberon-with-isa-mireot-disjv.txt
%-disjv.txt: %.obo
	blip -i -u query_anatomy "uberon_dv(X,Y,XD,YD)" -label > $@
uberon-dv.txt:
	blip -u ontol_manifest_disjoint_from_preceded_by -r uberon -u query_obo findall disjoint_from_violation/3 -label > $@
uberon-dv-%.txt:
	blip -u ontol_manifest_disjoint_from_preceded_by -r uberon -r $* -u query_obo findall xref_disjoint_from_violation_nr/3 -label > $@
uberon-jepd-dv-%.txt:
	blip -r uberon -r $* -u query_obo findall jepd_xref_disjoint_violation_nr/3 -label > $@
uberon-discv-%.txt:
	blip -u ontol_manifest_disconnected_from_adjacent -r uberon -r $* -u query_obo findall xref_disjoint_over_violation/4 -label > $@
uberon-discv.txt:
	blip -u ontol_manifest_disconnected_from_adjacent -r uberon  -u query_obo findall disjoint_over_violation/4 -label > $@

# no stemming
zfa-xao-aln.tbl:
	obol ontol-align -r zebrafish_anatomy -r xenopus_anatomy -shownames zebrafish_anatomy xenopus_anatomy > $@.tmp && mv $@.tmp $@

xao-fma-aln.tbl:
	obol ontol-align -r xenopus_anatomy -r fma_downcase -shownames -stem xenopus_anatomy fma > $@.tmp && mv $@.tmp $@

fly-fma-aln.tbl:
	obol ontol-align -r fly_anatomy -r fma_downcase -shownames -stem fly_anatomy.ontology fma > $@.tmp && mv $@.tmp $@

fly-worm-aln.tbl:
	obol ontol-align -r fly_anatomy -r worm_anatomy -shownames -stem fly_anatomy.ontology worm_anatomy > $@.tmp && mv $@.tmp $@

ant-chebi-aln.tbl:
	obol ontol-align -r ant -r chebi -shownames -stem ant chebi_ontology > $@.tmp && mv $@.tmp $@

%-cell-aln.tbl:
	obol ontol-align -r $* -r cell -shownames -stem $* cell > $@.tmp && mv $@.tmp $@

sao.obo:
	blip -r sao -u ontol_manifest_metadata_from_sao io-convert -to obo -o $@

cc-sao-aln.tbl:
#	obol ontol-align -u ontol_manifest_metadata_from_sao -r sao -r obo/cellular_component -shownames -stem cellular_component 'http://ccdb.ucsd.edu/SAO/1.2#' > $@.tmp && mv $@.tmp $@
	obol ontol-align -u ontol_manifest_downcase_synonym_from_name -u ontol_manifest_metadata_from_sao -r sao -r obo/cellular_component -shownames -stem > $@.tmp && mv $@.tmp $@

ma-to-fma-name.txt: mappings_MAandFMA.txt
	./parse-mappings.pl $< > $@.tmp && mv $@.tmp $@

ma-to-fma.txt: ma-to-fma-name.txt
	blip -r fma map-labels $< > $@.tmp && mv $@.tmp $@

#ma-to-fma.obo: ma-to-fma.txt
#	./mappings-to-obo.pl $< > $@.tmp && mv $@.tmp $@
ma-to-fma-m.pro: ma-to-fma.txt
	tbl2p -p match $< > $@
ma-to-fma.obo: ma-to-fma-m.pro
	blip -i $< -r fma -r mouse_anatomy -u query_anatomy findall matches_to_obo/0 > $@.tmp && mv $@.tmp $@

%-to-fma-homology.obo: %-fma-aln.tbl
	./aln-to-obo.pl $< > $@

%-newlinks.txt: %-imports.obo %.obo
	blip-reasoner -i $< -import_all -explain genus_differentia -explain genus > $@.tmp && mv $@.tmp $@

.PRECIOUS: %obo

%-implied.obo: %-imports.obo %.obo
	obo2obo -o -saveimpliedlinks $@ $<

%-show-implied: %-implied.obo
	obo-grep.pl -r 'is_a.*implied' $<

UBER_ANATS = -r caro -r worm_anatomy -r mouse_anatomy -r fly_anatomy -r zebrafish_anatomy -r fma -r cell -r miaa -r xenopus_anatomy
HOMOLS = -i fly-to-worm-homology.obo -i ma-to-fma.obo -i fly-to-fma-homology.obo -i zfa-to-fma-homology.obo -i xao-to-fma-homology.obo

xrefcheck:
	blip $(HOMOLS) $(UBER_ANATS) -u query_anatomy findall non_isom_xref/3 > $@.tmp && sort -u $@.tmp > $@

uber.pro:
	blip -debug anatomy $(UBER_ANATS) $(HOMOLS) -u query_anatomy findall write_all_group_facts/0 > $@.tmp && mv $@.tmp $@
.PRECIOUS: uber.pro

gau.pro:
	blip -debug anatomy $(UBER_ANATS) $(HOMOLS) -u query_anatomy findall build_ontology/0 > $@.tmp && mv $@.tmp $@

anu-%.pro:
	blip -u query_anatomy findall 'write_pair($*)' > $@.tmp && mv $@.tmp $@

nonisom:
	blip $(UBER_ANATS) -i fly-to-worm-homology.obo -i ma-to-fma.obo -i fly-to-fma-homology.obo -i zfa-to-fma-homology.obo -u query_anatomy findall nonisom_hset/2 > $@.tmp && mv $@.tmp $@

%_obo.obo: %.pro
	blip -i $< -f ontol_db:pro io-convert -to obo -o $@
.PRECIOUS: %_obo.obo


%_links.pro: %_obo.obo
	blip -debug query -table_pred ontol_db:subclassT/2 -u query_anatomy -i $< $(UBER_ANATS) findall write_all_link_facts > $@.tmp && mv $@.tmp $@
.PRECIOUS: uber_links.pro

uber_links_obo.obo: uber_links.pro
	blip -i $< -f ontol_db:pro io-convert -to obo -o $@
.PRECIOUS: uber_links_obo.obo

uber_alles.obo: uber_links_obo.obo uber_obo.obo	
	obo2obo -o $@ uber_links_obo.obo uber_obo.obo part_of.obo

%-with-isa.obo: %.obo
	blip -i $*.obo -u ontol_manifest_has_subclass_from_xref io-convert -to obo -o $@
.PRECIOUS: %-with-isa.obo

uberon-isa-to-%.obo: uberon.obo
	obo-grep.pl -r '^id: $*' $< > $@

%-mireot.obo: %.obo
	blip -table_pred ontol_db:bf_parentRT/2 -i $< -r fma_simple -r mouse_anatomy -r zebrafish_anatomy -r fly_anatomy -r xenopus_anatomy ontol-query -query "entity_xref(_,X),bf_parentRT(X,ID),entity_label(ID,_)" -to obo > $@.tmp && mv $@.tmp $@
.PRECIOUS: fma-mireot.obo


%-bridge.obo: %-with-isa.obo
	obo-filter-tags.pl -t id -t is_a $< | obo-grep.pl --neg -r 'id: UBERON' - | obo-grep.pl -r Term -  > $@

%-merged.obo: %.obo %-mireot.obo %-bridge.obo
	obo2obo -o $@ $< $*-mireot.obo $*-bridge.obo 

%_all.obo: %_links_obo.obo
	obo2obo -o $@ $< $*_obo.obo part_of.obo

uberon_edit-implied.obo: uberon_edit.obo
	obo2obo -allowdangling -o -saveimpliedlinks -allowdangling $@ $<

uberon_edit-mireot-implied.obo: uberon_edit-mireot.obo
	obo2obo -o -saveimpliedlinks $@ $<

uberon.obo: uberon_edit-implied.obo
	obo-filter-external.pl --xp2rel $< | egrep -v '^(domain|range):' > $@

%-cycles: %.obo
	blip-findall -i $< "subclass_cycle/2" -label

%-synclash: %.obo
	blip-findall -r goxp/biological_process_xp_uber_anatomy	 -u query_obo -i $< "same_label_as(X,Y,A,B,C),X@<Y,class_refcount(X,XC),class_refcount(Y,YC)" -select "same_label_as(X,Y,A,B,C,XC,YC)" -label > $@

%-xpmatches: %.obo
	blip-findall -u query_obo -i $< "differentium(A,R,X),differentium(B,R,X),A\=B,class_cdef(A,D),class_cdef(B,D),class_refcount(A,AC),class_refcount(B,BC)" -select "x(A,B,AC,BC)" -label

# these should be all false positives from string matching
uberon-anat-matches.txt:
	blip-findall -i uberon-with-isa-mireot.obo -index "metadata_db:entity_label(1,1)" "same_label_as(A,B),\+id_idspace(A,'UBERON'),\+id_idspace(B,'UBERON'),\+((entity_xref(U,A),entity_xref(U,B)))" -select A-B -label > $@

uberon-nonobvious-matches.txt:
	blip-findall -r fma_downcase -i uberon-with-isa-mireot.obo -index "metadata_db:entity_label(1,1)" "entity_xref(U,A),entity_xref(U,B),A@<B,entity_label(A,_),entity_label(B,_),\+((entity_label_or_synonym(A,N),entity_label_or_synonym(B,N))),id_idspace(U,'UBERON'),id_idspace(A,AX),id_idspace(B,BX),BX\=AX" -select A-B -label > $@

uberon-dv2.txt: uberon.obo
	 blip -import_all -i uberon-imports-full.obo -u query_anatomy findall xref_disjoint_violation/5 > $@.tmp && sort -u $@.tmp > $@

%-dv.txt: %.obo
	blip  -i $< -u query_obo findall disjointness_violationNR/3 > $@.tmp && sort -u $@.tmp > $@

%-to-caro.obo:
	 obo-promote-dbxref-to-relationship.pl --minimal --idspace CARO --relation is_a $*.obo > $@.tmp && mv $@.tmp $@

%-cmt.obo: %.obo
	obo-add-comments.pl animal_gross_anatomy/*/*.obo ../cell_type/cell.obo ../caro/caro.obo MIAA.obo animal_gross_anatomy/*/*/*.obo ~/cvs/fma-conversion/fma2/fma2.obo gemina_anatomy.obo birnlex_anatomy.obo NIF-GrossAnatomy.obo hao.obo HOG.obo efo_anat.obo $< > $@

uberon_ext.pro:
	blip -debug anatomy -r zebrafish_anatomy -r xenopus_anatomy -r uberon -u query_anatomy -i zfa-xao-aln.tbl findall extend_ontology/0 > $@

links-uberon-fma.txt:
	blip -debug anatomy -r fma2  -i uberon_edit.obo -u query_obo findall "parent_by_xref_nr(uberon,_,_,_)" -label > $@.tmp && cut -f3-8 $@.tmp | sort -u > $@

links-uberon-%.txt:
	blip -debug anatomy -r $*  -i uberon_edit.obo -u query_obo findall "parent_by_xref_nr(uberon,_,_,_)" -label > $@.tmp && cut -f3-8 $@.tmp | sort -u > $@

subclass-uberon-fma-birnlex.pro:
	blip -i uberon_edit.obo -r fma2 -i birnlex_anatomy.obo -u query_obo  findall -write_prolog -select "ontol_db:subclass(A,B)" "subclass_by_xref_confirmed(uberon,A,B)" > $@.tmp && cut -f3-5 $@.tmp | sort -u > $@

subclass-uberon-fma-cell.pro:
	blip -i uberon_edit.obo -r fma2 -r cell -u query_obo  findall -write_prolog -select "ontol_db:subclass(A,B)" "subclass_by_xref_confirmed(uberon,A,B)" > $@.tmp && cut -f3-5 $@.tmp | sort -u > $@

subclass-uberon-zebrafish-cell.pro:
	blip -i uberon_edit.obo -r zebrafish_anatomy -r cell -u query_obo  findall -write_prolog -select "ontol_db:subclass(A,B)" "subclass_by_xref_confirmed(uberon,A,B)" > $@.tmp && cut -f3-5 $@.tmp | sort -u > $@

subclass-uberon-fma-zebrafish.pro:
	blip -i uberon_edit.obo -r fma2 -r zebrafish_anatomy -u query_obo  findall -write_prolog -select "ontol_db:subclass(A,B)" "subclass_by_xref_confirmed(uberon,A,B)" > $@.tmp && cut -f3-5 $@.tmp | sort -u > $@

subclass-uberon-xenopus-zebrafish.pro:
	blip -i uberon_edit.obo -r xenopus_anatomy -r zebrafish_anatomy -u query_obo  findall -write_prolog -select "ontol_db:subclass(A,B)" "subclass_by_xref_confirmed(uberon,A,B)" > $@.tmp && cut -f3-5 $@.tmp | sort -u > $@

subclass-uberon-%.obo: subclass-uberon-%.pro 
	blip -i $< io-convert -to obo -o $@

subclass-uberon-%-merged.obo: subclass-uberon-%.obo
	obo-merge-tags.pl -t is_a uberon_edit.obo $< > $@

# re-routes is_a links
# supersedes the above?
move-uberon-%-diff.pro: uberon_edit.obo
	blip -i uberon_edit.obo -r $* -u query_obo findall 'xrefmove(C,P,P2)' -select "(retract(ontol_db:subclass(C,P)),assert(ontol_db:subclass(C,P2)))" -write_prolog  > $@
move-uberon-%.obo: move-uberon-%-diff.pro
	blip-ddb -i uberon_edit.obo -goalfile $< io-convert -to obo -o $@

add-df-uberon-%-diff.pro: uberon_edit.obo
	blip -r implied/uberon_edit.obo -r $* -u query_obo findall 'xrefaddR(develops_from,C,P)' -select "assert(ontol_db:restriction(C,develops_from,P))" -write_prolog  > $@
add-df-uberon-%.obo: add-df-uberon-%-diff.pro
	blip-ddb -i uberon_edit.obo -goalfile $< io-convert -to obo -o $@

birnlex_anatomy.obo:
	blip -u ontol_manifest_metadata_from_birnlex -r birnlex_anatomy io-convert -to obo -o $@

abstract-%-diff.pro: 
	blip -r $* -u query_anatomy findall 'fix_ehdaa(C,N,N2)' -select "(retract(metadata_db:entity_label(C,N)),assert(metadata_db:entity_label(C,N2)))" -write_prolog  > $@
.PRECIOUS: abstract-%-diff.pro

abstract-%.obo: abstract-%-diff.pro
	blip-ddb -r $* -goalfile $< io-convert -to obo -o $@

fma_s.obo: 
	blip -u ontol_manifest_synonym_from_fma.pro -r fma2 io-convert -to obo -o $@.tmp && ./downcase-obo.pl $@.tmp > $@

birnlex_anatomy_s.obo: nif_anatomy.obo
	blip -u ontol_manifest_synonym_from_birnlex_anatomy.pro -i $< io-convert -to obo -o $@

uberon-grep-go.pro: 
	obol -r obol_av -debug obol -u onto_grep -i uberon_edit.obo -r go onto-grep  -optimize -query "belongs(ID,biological_process)" > $@.tmp && mv $@.tmp $@

align-uberon-%.obo:
	obol -u onto_grep -r $* -i uberon_edit.obo onto-exact-align -ont2 uberon -exclude_xref_strict -exclude_xref -disp 'format(obo)' > $@.tmp && mv $@.tmp $@
.PRECIOUS: align-uberon-%.obo

merge-uberon-%.obo: align-uberon-%.obo
	obo-merge-tags.pl -t xref  uberon_edit.obo $< > $@

uberon-go-defs.txt:
	blip -r go $(GO_XP_ARGS) -u ontol_db findall "belongs(X,uberon),differentium(Y,_,X),def(Y,D),belongs(Y,biological_process),(\+ def(X,_) ; def(X,'.'))" -select "td(X,Y,D)" -label > $@.tmp && sort -u $@.tmp > $@

%-syns.obo: %.obo
	obol -debug obol -i $<  -u obol_anat_xpgen obol-generate-synonyms -query "id_idspace(ID,'UBERON'),genus(ID,_)" > $@.tmp && mv $@.tmp $@


uberon-mouse-missing-below-%.txt:
	blip -i adult_mouse_xp.obo -r uberon -r mouse_anatomy -u ontol_db findall "parentT(X,'$*'),\+ entity_xref(_,X),(genus(X,G)->true;G='')" -select X-G -label > $@.tmp && sort -u $@.tmp > $@

newterms-fma-mouse.obo:
	obol -u onto_grep onto-3-way-align -r mouse_anatomy -r fma2 -r uberon -ont1 adult_mouse_anatomy.gxd -ont2 fma -ont3 uberon > $@

newterms-fma-envo.obo:
	obol -u onto_grep onto-3-way-align -r envo -r fma -r uberon -ont1 ENVO -ont2 fma -ont3 uberon > $@

newterms-fma-cyc.obo:
	obol -u onto_grep onto-3-way-align -r envo -i opencyc2.obo -r uberon -ont1 http://sw.opencyc.org/concept/ -ont2 fma -ont3 uberon > $@

newterms-fma-gemina.obo:
	obol -u onto_grep onto-3-way-align -r fma_downcase -r gemina_anatomy -r uberon -ont1 gemina_anatomy -ont2 fma -ont3 uberon > $@

newterms-fma-nif.obo: 
	obol -u onto_grep onto-3-way-align -r fma_downcase -r nif_downcase -i uberon_CL.obo -r uberon -ont1 birnlex_anatomy -ont2 fma -ont3 uberon > $@

newterms-mouse-birnlex.obo: birnlex_anatomy_s.obo
	obol -u onto_grep onto-3-way-align -i $< -r mouse_anatomy -r uberon -ont1 birnlex_anatomy -ont2 adult_mouse_anatomy.gxd -ont3 uberon > $@

newterms-xenopus-zebrafish.obo:
	obol -u onto_grep onto-3-way-align -i uberon_CL -r xenopus_anatomy -r zebrafish_anatomy -r uberon -ont1 zebrafish_anatomy -ont2 xenopus_anatomy -ont3 uberon > $@

newterms-zebrafish-mouse.obo:
	obol -u onto_grep onto-3-way-align -r mouse_anatomy -r zebrafish_anatomy -r uberon -ont1 adult_mouse_anatomy.gxd -ont2 zebrafish_anatomy -ont3 uberon > $@

newterms-xenopus-mouse.obo:
	obol -u onto_grep onto-3-way-align -r mouse_anatomy -r xenopus_anatomy -r uberon -ont1 adult_mouse_anatomy.gxd -ont2 xenopus_anatomy -ont3 uberon > $@

newterms-zebrafish-birnlex.obo: birnlex_anatomy_s.obo
	obol -u onto_grep onto-3-way-align -i $< -r zebrafish_anatomy -r uberon -ont1 birnlex_anatomy -ont2 adult_mouse_anatomy.gxd -ont3 uberon > $@

newterms-zebrafish-fma.obo: fma_s.obo
	obol -u onto_grep onto-3-way-align -i $< -r zebrafish_anatomy -r uberon -ont1 fma -ont2 adult_mouse_anatomy.gxd -ont3 uberon > $@

newterms-zebrafish-fly.obo:
	obol -u onto_grep onto-3-way-align -r fly_anatomy -r zebrafish_anatomy -r uberon -ont1 fly_anatomy.ontology -ont2 zebrafish_anatomy -ont3 uberon > $@

newterms-hao-fly.obo:
	obol -u onto_grep onto-3-way-align -r fly_anatomy -r hao -r uberon -ont1 fly_anatomy.ontology -ont2 HAO -ont3 uberon > $@

newterms-zebrafish-ehdaa.obo:
	obol -u onto_grep onto-3-way-align -r ehdaa -r zebrafish_anatomy -r uberon -ont1 human-dev-anat-abstract -ont2 zebrafish_anatomy -ont3 uberon > $@

newterms-fma-ehdaa.obo:
	obol -u onto_grep onto-3-way-align -r ehdaa -r fma -r uberon -ont1 human-dev-anat-abstract -ont2 fma -ont3 uberon > $@

newterms-emapa-ehdaa.obo:
	obol -u onto_grep onto-3-way-align -r ehdaa -r emapa -r uberon -ont1 human-dev-anat-abstract -ont2 abstract_anatomy -ont3 uberon > $@

newterms-mosquito-fly.obo:
	obol -u onto_grep onto-3-way-align -r fly_anatomy -r mosquito_anatomy -r uberon -ont1 fly_anatomy.ontology -ont2 default_namespace -ont3 uberon > $@

newterms-spider-fly.obo:
	obol -u onto_grep onto-3-way-align -r fly_anatomy -r obo/spider_anatomy -r uberon -ont1 fly_anatomy.ontology -ont2 spider_anatomy -ont3 uberon > $@

newterms-brenda-fma.obo:
	obol -u onto_grep onto-3-way-align -r fma_downcase -r obo/brenda -r uberon -ont1 BrendaTissue545 -ont2 fma -ont3 uberon > $@

newterms-ncit-fma.obo:
	obol -u onto_grep onto-3-way-align -r fma -r ncit -r uberon -ont1 fma -ont2 'ncithesaurus:' -ont3 uberon > $@

newterms-ncit-emapa.obo:
	obol -u onto_grep onto-3-way-align -r emapa -r ncit -r uberon -ont1 emapa -ont2 'ncithesaurus:' -ont3 uberon > $@

newterms-ncit-xao.obo:
	obol -u onto_grep onto-3-way-align -r xenopus_anatomy -r ncit -r uberon -ont1 xenopus_anatomy -ont2 'ncithesaurus:' -ont3 uberon > $@

# --
# creation of classes based on xps in external ontologies
# --

uberon-xp-new-ma.pro:
	blip -i adult_mouse_xp.obo -r mouse_anatomy -r uberon -u query_anatomy -u ontol_db findall "uberon_xp(Fact)"  -select Fact -write_prolog  > $@

uberon-xp-new-fma.pro:
	blip -i fma_xp.obo -r fma -r uberon -u query_anatomy -u ontol_db findall "uberon_xp(Fact)"  -select Fact -write_prolog  > $@

uberon-xp-new-fma-u.pro:
	blip -i fma_xp.obo -i fma_xp_uberon.obo -r fma -r uberon -u query_anatomy -u ontol_db findall "uberon_xp(Fact)"  -select Fact -write_prolog  > $@

#uberon-xp-new-ma.pro:
#	blip -i adult_mouse_xp.obo -r mouse_anatomy -r uberon -u query_anatomy -u ontol_db findall "uberon_xp(Fact)"  -select Fact -write_prolog  > $@

# --
# alignment of classes based on xps in external ontologies and in uberon
# --
uberon-xp-xref-ma.obo:
	blip -i adult_mouse_xp.obo -i adult_mouse_xp_uberon.obo -r mouse_anatomy -r uberon -u query_anatomy -u ontol_db findall "uberon_xp_align_write/0"  > $@

uberon-xp-xref-fma.obo:
	blip -i fma_xp.obo -i fma_xp_uberon.obo -r fma -r uberon -u query_anatomy -u ontol_db findall "uberon_xp_align_write/0"  > $@

uberon-xp-xref-zfa.obo:
	blip -i zebrafish_anatomy_xp.obo -r zebrafish_anatomy -r uberon -u query_anatomy -u ontol_db findall "uberon_xp_align_write/0"  > $@

uberon-xp-xref-hog.obo:
	blip -i hog_xp.obo -r hog -r uberon -u query_anatomy -u ontol_db findall "uberon_xp_align_write/0"  > $@

uberon-xp-xref-xao.obo:
	blip -i xenopus_anatomy_xp.obo -r xenopus_anatomy -r uberon -u query_anatomy -u ontol_db findall "uberon_xp_align_write/0"  > $@

newxp-%-ontol_db.pro:
	blip -r $* -i $*_xp.obo -i uberon_edit.obo -u query_anatomy findall "uberon_xp(Fact)" -select Fact -write_prolog > $@.tmp && sort -u $@.tmp > $@
.PRECIOUS: newxp-%-ontol_db.pro

newxp-%-ontol_db.obo: newxp-%-ontol_db.pro
	blip -i $< -f ontol_db:pro io-convert -to obo -o $@

uberon-new-mp.obo:
	blip -u query_anatomy -i uberon_edit.obo -r cell -r emap -r emapa -r mammalian_phenotype -r mammalian_phenotype_xp -r fma_downcase -r nif_downcase -r zebrafish_anatomy -r emapa -r mammalian_phenotype_xp_nif -r mouse_anatomy findall uberon_mpxp_write > $@

uberon-new-hp.obo:
	blip -u query_anatomy -i uberon_edit.obo -r cell -r human_phenotype -r human_phenotype_xp -r nif_downcase -r zebrafish_anatomy -r mouse_anatomy -r emapa -goal "uberon_mpxp_write,halt" > $@

uberon-new-go.obo:
	blip -u query_anatomy -i uberon_edit.obo -r cell -r go -r goxp/biological_process_xp_uber_anatomy -r nif_downcase -r zebrafish_anatomy -r mouse_anatomy -r emapa -r goxp/biological_process_xp_fly_anatomy -r goxp/biological_process_xp_plant_anatomy -r goxp/biological_process_xp_zebrafish_anatomy -goal "uberon_goxp_write,halt" > $@

uberon-defs-from-mp.obo:
	blip -u query_anatomy -i uberon_edit.obo -r mammalian_phenotype  -goal "uberon_mpxp_write_defs,halt" > $@

%.xrefcount: %.obo
	blip -i $< -u ontol_db findall -label '(class(C),setof_count(X,class_xref(C,X),Num))' -select 'C-Num' | sort -k3 -n > $@

%-wikipedia.xrefs: %.obo
	(blip -i $< -u web_fetch_wikipedia -u query_anatomy findall class_wikipage/2 > $@) >& $@.err

%-wikipedia.pro: %-wikipedia.xrefs
	./wikitbl2defxref.pl $< | tbl2p > $@

%-wikipedia.merge: %-wikipedia.xrefs
	./wikitbl2defxref.pl $< | cut -f2,3 | tbl2obolinks.pl --rel xref > $@

nif_anatomy.obo:
	blip -i http://ontology.neuinfo.org/NIF/BiomaterialEntities/NIF-GrossAnatomy.owl -f thea2_owl -import_all io-convert -to obo -u ontol_manifest_metadata_from_nif_via_thea -o $@.tmp && ./downcase-obo.pl $@.tmp > $@

nif_subcellular.obo:
	blip -i http://ontology.neuinfo.org/NIF/BiomaterialEntities/NIF-Subcellular.owl -f thea2_owl -import_all io-convert -to obo -u ontol_manifest_metadata_from_nif_via_thea -o $@.tmp && ./nif-downcase-obo.pl $@.tmp > $@

nif_cell.obo:
	blip -i http://ontology.neuinfo.org/NIF/BiomaterialEntities/NIF-Cell.owl -f thea2_owl -import_all io-convert -to obo -u ontol_manifest_metadata_from_nif_via_thea -o $@.tmp && ./nif-downcase-obo.pl $@.tmp > $@

nif_anatomy_xp.obo: nif_anatomy.obo
	obol  -i $< -table_pred user:gross_anatomical/3 -table_pred user:gross_anatomical5/3  -table_pred classdef_parser:any_kind_of/3  -table_pred ontol_db:subclassT/2 -u obol_nif_anatomy_xp -r obol_av  obol-parse -parse_rule anatomical_continuant "belongs(ID,birnlex_anatomy)" >& $@.tmp && mv $@.tmp $@

nif_subcellular_xp.obo: nif_subcellular.obo
	obol  -i $< -i nif_cell.obo -table_pred user:gross_anatomical/3 -table_pred user:anatomical_continuant5/3  -table_pred classdef_parser:any_kind_of/3  -table_pred ontol_db:subclassT/2 -u obol_nif_subcellular_xp -r obol_av  obol-parse -parse_rule anatomical_continuant "class(ID),id_idspace(ID,'NIF_Subcellular')" >& $@.tmp && mv $@.tmp $@


EMAPAx-1.obo: EMAPA.obo
	blip -u emapa -i $< io-convert -to obo -o $@
.PRECIOUS: EMAPAx-1.obo


EMAPAx-2.obo: EMAPAx-1.obo
	obo-sed.pl -r intersection_of 's/\nname: .*//'  $< | obo-sed.pl -r 'namespace: emapax' 's/id: EMAPA:(.*)/id: EMAPA:$$1\nname: $$1/' > $@


%.obd:
	obd-create-db.pl -d $* $*-norel-imports.obo && touch $@
.PRECIOUS: %.obd

%.obdr: %.obd
	obd-reasoner.pl -d $* && touch $@
.PRECIOUS: %.obdr

%-inf.txt: %.obdr
	./mk-obd-inf.sh $* $(IDSPACE)  > $@
.PRECIOUS: %-inf.txt
%-inf.pro: %-inf.txt
	tbl2p -p inf $< > $@
.PRECIOUS: %-inf.pro

%xp-truepos.txt: %xp-inf.pro
	blip -i $< -i $*.obo -u ontol_db findall "(inf(X,Y),subclassT(X,Y))" -select "recap(X,Y)" -label > $@.tmp && sort -u $@.tmp > $@
%xp-falseneg.txt: %xp-inf.pro
	blip -i $< -i $*.obo -i $*_xp.obo -u ontol_db findall "(genus(X,_),subclass(X,Y),genus(Y,_),\+inf(X,Y))" -select "problem(X,Y)" -label > $@.tmp && sort -u $@.tmp > $@
%xp-novel.txt: %xp-inf.pro
	blip -i $< -i $*.obo -u ontol_db findall "(inf(X,Y),\+subclassT(X,Y),\+inf(Y,X),\+((inf(X,Z),inf(Z,Y))))" -select "novel(X,Y)" -label > $@.tmp && sort -u $@.tmp > $@
%xp-novel-filtered.txt: %xp-novel.txt
	perl -ne 'print unless /\d\n/' $< > $@
%xp-equiv.txt: %xp-inf.pro
	blip -i $< -i $*.obo -u ontol_db findall "(inf(X,Y),X@<Y,inf(Y,X))" -select "equiv(X,Y)" -label > $@.tmp && sort -u $@.tmp > $@

organ_association.txt:
	wget http://bgee.unil.ch/download/organ_association.txt

fma-mireot.obo: fma_xp.obo
	blip -i $< -r fma_simple ontol-subset -rel subclass -rel part_of -query "differentium(_,_,ID);genus(_,ID)" -to obo > $@.tmp && mv $@.tmp $@
.PRECIOUS: fma-mireot.obo

mappings-FMA-MA.cmp: mappings-FMA-MA.rdf
	blip-findall -r uberon -r mouse_anatomy -r fma -i mappings-FMA-MA.rdf -u metadata_mappings -table_pred "ontol_db:bf_parentRT/2" -index "metadata_db:entity_label(1,1)" "compare_mapping(uberon,bp,_,_,_,_,_)" -label > $@
#	blip-findall -r uberon -r mouse_anatomy -r fma -i mappings-FMA-MA.rdf -u ontol_bridge_from_bp_mappings -index "metadata_db:entity_label(1,1)" "compare_mapping/4" -label > $@

