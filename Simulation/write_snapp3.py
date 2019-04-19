##### Function for writing SNAPP xml file from nexus file #####

def write_snapp(file_name,npops,indsperpop,taxa_names,seqs): # file_name = name of input nexus file; npops = number of populations/species; indsperpop = number of samples per pop/species; taxa_names = list of names for each sample; seqs = binary snps

### Define variables
	chain_length = 1000000
	chain_store = 1000
	name_cat = file_name.split('.')[0]

	xml_name = name_cat + '.xml' # create xml file name
	snapp = open(xml_name, 'w+') # create xml file

	snapp.writelines('\
<?xml version="1.0" encoding="UTF-8" standalone="no"?><beast beautitemplate=\'SNAPP\' beautistatus=\'\' namespace="beast.core:beast.evolution.alignment:beast.evolution.tree.coalescent:beast.core.util:beast.evolution.nuc:beast.evolution.operators:beast.evolution.sitemodel:beast.evolution.substitutionmodel:beast.evolution.likelihood" required="SNAPP v1.3.0" version="2.4">\n\
\n\
\n\
    <data\n\
id="{0}"\n\
dataType="integer"\n\
name="rawdata">\n\
'.format(name_cat))

	for ind in range(0,len(taxa_names),1):
		line = '                    <sequence id="seq_{0}" taxon="{0}" totalcount="3" value="{1}"/>\n'.format(taxa_names[ind], seqs[ind])
		snapp.writelines(line)
	
	snapp.writelines('\
                </data>\n\
\n\
\n\
    \n\
\n\
\n\
    \n\
\n\
\n\
    \n\
<map name="Uniform" >beast.math.distributions.Uniform</map>\n\
<map name="Exponential" >beast.math.distributions.Exponential</map>\n\
<map name="LogNormal" >beast.math.distributions.LogNormalDistributionModel</map>\n\
<map name="Normal" >beast.math.distributions.Normal</map>\n\
<map name="Beta" >beast.math.distributions.Beta</map>\n\
<map name="Gamma" >beast.math.distributions.Gamma</map>\n\
<map name="LaplaceDistribution" >beast.math.distributions.LaplaceDistribution</map>\n\
<map name="prior" >beast.math.distributions.Prior</map>\n\
<map name="InverseGamma" >beast.math.distributions.InverseGamma</map>\n\
<map name="OneOnX" >beast.math.distributions.OneOnX</map>\n\
\n\
\n\
<run id="mcmc" spec="MCMC" chainLength="{0}" preBurnin="100000" storeEvery="{1}">\n\
    <state id="state" storeEvery="{1}">\n\
        <stateNode id="Tree.{2}" spec="beast.util.ClusterTree" clusterType="upgma" nodetype="snap.NodeData">\n\
            <taxa id="snap.{2}" spec="snap.Data" dataType="integerdata">\n\
                <rawdata idref="{2}"/>\n\
'.format(chain_length, chain_store, name_cat))

	for pop in range(0,npops,1):
		snapp.writelines('\
                <taxonset id="{0}" spec="TaxonSet">\n\
'.format(pop + 1))
	
		for sample in range(0,indsperpop,1):
			snapp.writelines('\
                    <taxon id="{0}" spec="Taxon"/>\n\
'.format(taxa_names[(pop*indsperpop):((pop + 1)*indsperpop)][sample]))
		
		snapp.writelines('\
                </taxonset>\n\
')

	snapp.writelines('\
            </taxa>\n\
            <parameter id="RealParameter.0" lower="0.0" name="clock.rate" upper="0.0">1.0</parameter>\n\
        </stateNode>\n\
        <parameter id="lambda" lower="0.0" name="stateNode">0.01</parameter>\n\
        <parameter id="coalescenceRate" name="stateNode">10.0</parameter>\n\
    </state>\n\
\n\
    <distribution id="posterior" spec="util.CompoundDistribution">\n\
        <distribution id="prior" spec="util.CompoundDistribution">\n\
            <prior id="lambdaPrior.{0}" name="distribution" x="@lambda">\n\
                <Gamma id="Gamma.0" name="distr">\n\
                    <parameter id="RealParameter.1" estimate="false" name="alpha">2.0</parameter>\n\
                    <parameter id="RealParameter.2" estimate="false" name="beta">200.0</parameter>\n\
                </Gamma>\n\
            </prior>\n\
            <distribution id="snapprior.{0}" spec="snap.likelihood.SnAPPrior" coalescenceRate="@coalescenceRate" lambda="@lambda" rateprior="gamma" tree="@Tree.{0}">\n\
                <parameter id="alpha" estimate="false" lower="0.0" name="alpha">11.75</parameter>\n\
                <parameter id="beta" estimate="false" lower="0.0" name="beta">109.73</parameter>\n\
                <parameter id="kappa" estimate="false" lower="0.0" name="kappa">1.0</parameter>\n\
            </distribution>\n\
        </distribution>\n\
        <distribution id="likelihood" spec="util.CompoundDistribution">\n\
            <distribution id="treeLikelihood.{0}" spec="snap.likelihood.SnAPTreeLikelihood" data="@snap.{0}" non-polymorphic="false" pattern="coalescenceRate" tree="@Tree.{0}">\n\
                <siteModel id="MutationSiteModel.{0}" spec="SiteModel">\n\
                    <parameter id="mutationRate" estimate="false" name="mutationRate">1.0</parameter>\n\
                    <parameter id="shape" estimate="false" name="shape">2.0</parameter>\n\
                    <parameter id="proportionInvariant" estimate="false" name="proportionInvariant">0.0</parameter>\n\
                    <substModel id="MutationModel" spec="snap.likelihood.SnapSubstitutionModel" coalescenceRate="@coalescenceRate">\n\
                        <parameter id="u" estimate="false" lower="0.0" name="mutationRateU">1.0</parameter>\n\
                        <parameter id="v" lower="0.0" name="mutationRateV">1.0</parameter>\n\
                    </substModel>\n\
                </siteModel>\n\
            </distribution>\n\
        </distribution>\n\
    </distribution>\n\
\n\
    <operator id="NodeSwapper" spec="snap.operators.NodeSwapper" tree="@Tree.{0}" weight="0.5"/>\n\
\n\
    <operator id="NodeBudger" spec="snap.operators.NodeBudger" size="0.5" tree="@Tree.{0}" weight="0.5"/>\n\
\n\
    <operator id="TreeScaler" spec="snap.operators.ScaleOperator" scaleFactor="0.25" tree="@Tree.{0}" weight="0.5"/>\n\
\n\
    <operator id="GammaMover" spec="snap.operators.GammaMover" coalescenceRate="@coalescenceRate" scale="0.5" weight="8.0"/>\n\
\n\
    <operator id="RateMixer" spec="snap.operators.RateMixer" coalescenceRate="@coalescenceRate" scaleFactors="0.25" tree="@Tree.{0}" weight="1.0"/>\n\
\n\
    <operator id="lambdaScaler" spec="snap.operators.ScaleOperator" parameter="@lambda" scaleFactor="0.75" weight="1.0"/>\n\
\n\
    <logger id="tracelog" fileName="{0}_snap.log" logEvery="{1}" model="@posterior">\n\
        <log idref="posterior"/>\n\
        <log idref="likelihood"/>\n\
        <log idref="prior"/>\n\
        <log id="ThetaLogger" spec="snap.ThetaLogger" coalescenceRate="@coalescenceRate"/>\n\
        <log id="TreeHeightLogger" spec="beast.evolution.tree.TreeHeightLogger" tree="@Tree.{0}"/>\n\
    </logger>\n\
\n\
    <logger id="screenlog" logEvery="{1}">\n\
        <log idref="posterior"/>\n\
        <log id="ESS.0" spec="util.ESS" arg="@posterior"/>\n\
        <log idref="likelihood"/>\n\
        <log idref="prior"/>\n\
    </logger>\n\
\n\
    <logger id="treelog" fileName="{0}_snap.trees" logEvery="{1}" mode="tree">\n\
        <log id="TreeWithMetaDataLogger.{0}" spec="beast.evolution.tree.TreeWithMetaDataLogger" tree="@Tree.{0}">\n\
            <metadata id="theta" spec="snap.RateToTheta" coalescenceRate="@coalescenceRate"/>\n\
        </log>\n\
    </logger>\n\
\n\
</run>\n\
\n\
</beast>\n\
'.format(name_cat, chain_store))

	snapp.close() # close file connection
